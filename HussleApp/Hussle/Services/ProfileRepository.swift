import Foundation

actor ProfileRepository {
    private let client: SupabaseRESTClient
    private let storage: StorageService

    init(client: SupabaseRESTClient = SupabaseRESTClient(), storage: StorageService = StorageService()) {
        self.client = client
        self.storage = storage
    }

    func loadOwner(userID: UUID, token: String) async throws -> RemoteProfile? {
        let rows: [RemoteProfile] = try await client.request(
            path: "/rest/v1/profiles",
            queryItems: [
                URLQueryItem(name: "id", value: "eq.\(userID.uuidString)"),
                URLQueryItem(name: "select", value: "*")
            ], accessToken: token, responseType: [RemoteProfile].self)
        return rows.first
    }

    func upsertOwner(_ profile: RemoteProfile, token: String) async throws -> RemoteProfile {
        let body = try JSONEncoder.supabase.encode([profile])
        let rows: [RemoteProfile] = try await client.request(
            path: "/rest/v1/profiles", method: "POST", body: body, accessToken: token,
            headers: ["Prefer": "resolution=merge-duplicates,return=representation"], responseType: [RemoteProfile].self)
        guard let result = rows.first else { throw SupabaseRESTClient.ClientError.invalidResponse }
        return result
    }

    func loadDogs(ownerID: UUID, token: String) async throws -> [RemoteDog] {
        try await client.request(
            path: "/rest/v1/dogs",
            queryItems: [
                URLQueryItem(name: "owner_id", value: "eq.\(ownerID.uuidString)"),
                URLQueryItem(name: "select", value: "*")
            ], accessToken: token, responseType: [RemoteDog].self)
    }

    func upsertDog(_ dog: RemoteDog, token: String) async throws -> RemoteDog {
        let body = try JSONEncoder.supabase.encode([dog])
        let rows: [RemoteDog] = try await client.request(
            path: "/rest/v1/dogs", method: "POST", body: body, accessToken: token,
            headers: ["Prefer": "resolution=merge-duplicates,return=representation"], responseType: [RemoteDog].self)
        guard let result = rows.first else { throw SupabaseRESTClient.ClientError.invalidResponse }
        return result
    }

    func loadVaccinations(dogID: UUID, token: String) async throws -> [Vaccination] {
        let rows: [RemoteVaccination] = try await client.request(
            path: "/rest/v1/vaccinations",
            queryItems: [
                URLQueryItem(name: "dog_id", value: "eq.\(dogID.uuidString)"),
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "order", value: "administered_on.desc")
            ], accessToken: token, responseType: [RemoteVaccination].self)
        return rows.map(\.local)
    }

    func replaceVaccinations(_ vaccinations: [Vaccination], dogID: UUID, token: String) async throws {
        _ = try await client.requestData(
            path: "/rest/v1/vaccinations",
            method: "DELETE",
            queryItems: [URLQueryItem(name: "dog_id", value: "eq.\(dogID.uuidString)")],
            accessToken: token,
            headers: ["Prefer": "return=minimal"]
        )
        guard !vaccinations.isEmpty else { return }
        let body = try JSONEncoder.supabase.encode(vaccinations.map { RemoteVaccination(local: $0, dogID: dogID) })
        _ = try await client.requestData(
            path: "/rest/v1/vaccinations",
            method: "POST",
            body: body,
            accessToken: token,
            headers: ["Content-Type": "application/json", "Prefer": "return=minimal"]
        )
    }

    func loadPhotos(dogID: UUID, token: String) async throws -> [Data] {
        let rows: [RemoteDogPhoto] = try await client.request(
            path: "/rest/v1/dog_photos",
            queryItems: [
                URLQueryItem(name: "dog_id", value: "eq.\(dogID.uuidString)"),
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "order", value: "sort_order.asc")
            ], accessToken: token, responseType: [RemoteDogPhoto].self)

        var result: [Data] = []
        for row in rows {
            if let data = try? await storage.downloadDogPhoto(path: row.storagePath, token: token) {
                result.append(data)
            }
        }
        return result
    }

    func replacePhotos(_ photos: [Data], ownerID: UUID, dogID: UUID, token: String) async throws {
        let existing: [RemoteDogPhoto] = try await client.request(
            path: "/rest/v1/dog_photos",
            queryItems: [
                URLQueryItem(name: "dog_id", value: "eq.\(dogID.uuidString)"),
                URLQueryItem(name: "select", value: "*")
            ], accessToken: token, responseType: [RemoteDogPhoto].self)

        for item in existing {
            try? await storage.deleteDogPhoto(path: item.storagePath, token: token)
        }
        _ = try await client.requestData(
            path: "/rest/v1/dog_photos",
            method: "DELETE",
            queryItems: [URLQueryItem(name: "dog_id", value: "eq.\(dogID.uuidString)")],
            accessToken: token,
            headers: ["Prefer": "return=minimal"]
        )

        var records: [NewRemoteDogPhoto] = []
        for (index, data) in photos.prefix(6).enumerated() {
            let compressed = ImageCompressor.jpegData(from: data, maxDimension: 1600, compressionQuality: 0.82) ?? data
            let path = try await storage.uploadDogPhoto(compressed, ownerID: ownerID, dogID: dogID, index: index, token: token)
            records.append(NewRemoteDogPhoto(dogId: dogID, storagePath: path, sortOrder: index))
        }
        guard !records.isEmpty else { return }
        let body = try JSONEncoder.supabase.encode(records)
        _ = try await client.requestData(
            path: "/rest/v1/dog_photos",
            method: "POST",
            body: body,
            accessToken: token,
            headers: ["Content-Type": "application/json", "Prefer": "return=minimal"]
        )
    }

    func saveCompleteDog(_ dog: Dog, ownerID: UUID, token: String) async throws {
        _ = try await upsertDog(RemoteDog(local: dog, ownerID: ownerID), token: token)
        try await replaceVaccinations(dog.vaccinations, dogID: dog.id, token: token)
        try await replacePhotos(dog.photoData, ownerID: ownerID, dogID: dog.id, token: token)
    }
}
