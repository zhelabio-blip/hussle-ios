import Foundation

actor StorageService {
    private let client: SupabaseRESTClient

    init(client: SupabaseRESTClient = SupabaseRESTClient()) {
        self.client = client
    }

    func uploadDogPhoto(_ data: Data, ownerID: UUID, dogID: UUID, index: Int, token: String) async throws -> String {
        let path = "\(ownerID.uuidString)/\(dogID.uuidString)/photo-\(index)-\(UUID().uuidString).jpg"
        _ = try await client.requestData(
            path: "/storage/v1/object/dog-photos/\(path)",
            method: "POST",
            body: data,
            accessToken: token,
            headers: ["Content-Type": "image/jpeg", "x-upsert": "true"]
        )
        return path
    }

    func downloadDogPhoto(path: String, token: String) async throws -> Data {
        try await client.requestData(
            path: "/storage/v1/object/authenticated/dog-photos/\(path)",
            accessToken: token
        )
    }

    func deleteDogPhoto(path: String, token: String) async throws {
        _ = try await client.requestData(
            path: "/storage/v1/object/dog-photos/\(path)",
            method: "DELETE",
            accessToken: token
        )
    }
}
