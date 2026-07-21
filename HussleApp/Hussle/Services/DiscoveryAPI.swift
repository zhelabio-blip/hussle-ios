import Foundation

actor DiscoveryAPI {
    private let client: SupabaseRESTClient

    init(client: SupabaseRESTClient = SupabaseRESTClient()) {
        self.client = client
    }

    func fetchDogs(activeDogId: UUID, radiusKm: Double, accessToken: String) async throws -> [RemoteDog] {
        struct Payload: Encodable {
            let activeDogId: UUID
            let radiusKm: Double
        }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(Payload(activeDogId: activeDogId, radiusKm: radiusKm))
        return try await client.request(
            path: "/rest/v1/rpc/discover_dogs",
            method: "POST",
            body: body,
            accessToken: accessToken,
            responseType: [RemoteDog].self
        )
    }
}
