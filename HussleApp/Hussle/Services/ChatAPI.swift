import Foundation

struct ChatAPI: Sendable {
    private let client = SupabaseRESTClient()

    func fetchMatches(activeDogID: UUID, accessToken: String) async throws -> [RemoteMatchSummary] {
        let body = try JSONSerialization.data(withJSONObject: ["active_dog_id": activeDogID.uuidString])
        return try await client.request(
            path: "/rest/v1/rpc/get_my_matches",
            method: "POST",
            body: body,
            accessToken: accessToken,
            responseType: [RemoteMatchSummary].self
        )
    }

    func fetchMessages(conversationID: UUID, accessToken: String) async throws -> [RemoteChatMessage] {
        let body = try JSONSerialization.data(withJSONObject: ["requested_conversation_id": conversationID.uuidString])
        return try await client.request(
            path: "/rest/v1/rpc/get_conversation_messages",
            method: "POST",
            body: body,
            accessToken: accessToken,
            responseType: [RemoteChatMessage].self
        )
    }

    func sendMessage(conversationID: UUID, body text: String, accessToken: String) async throws -> SendMessageResult {
        let body = try JSONSerialization.data(withJSONObject: [
            "requested_conversation_id": conversationID.uuidString,
            "message_body": text
        ])
        let rows: [SendMessageResult] = try await client.request(
            path: "/rest/v1/rpc/send_chat_message",
            method: "POST",
            body: body,
            accessToken: accessToken,
            responseType: [SendMessageResult].self
        )
        guard let result = rows.first else { throw SupabaseRESTClient.ClientError.invalidResponse }
        return result
    }
}
