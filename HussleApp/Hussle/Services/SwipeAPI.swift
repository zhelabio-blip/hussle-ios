import Foundation

actor SwipeAPI {
    private let client: SupabaseRESTClient

    init(client: SupabaseRESTClient = SupabaseRESTClient()) {
        self.client = client
    }

    func record(sourceDogID: UUID, targetDogID: UUID, action: String, accessToken: String) async throws -> SwipeResult {
        struct Payload: Encodable {
            let sourceDogId: UUID
            let targetDogId: UUID
            let swipeAction: String
        }
        let body = try JSONEncoder.supabase.encode(
            Payload(sourceDogId: sourceDogID, targetDogId: targetDogID, swipeAction: action)
        )
        return try await client.request(
            path: "/rest/v1/rpc/record_swipe",
            method: "POST",
            body: body,
            accessToken: accessToken,
            responseType: SwipeResult.self
        )
    }
}
