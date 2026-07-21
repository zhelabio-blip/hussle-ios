import Foundation

struct SafetyAPI: Sendable {
    private let client = SupabaseRESTClient()

    func unmatch(matchID: UUID, accessToken: String) async throws {
        let body = try JSONSerialization.data(withJSONObject: ["requested_match_id": matchID.uuidString])
        _ = try await client.requestData(path: "/rest/v1/rpc/unmatch_dogs", method: "POST", body: body, accessToken: accessToken, headers: ["Content-Type": "application/json"])
    }

    func block(userID: UUID, accessToken: String) async throws {
        let body = try JSONSerialization.data(withJSONObject: ["blocked_user_id": userID.uuidString])
        _ = try await client.requestData(path: "/rest/v1/rpc/block_user", method: "POST", body: body, accessToken: accessToken, headers: ["Content-Type": "application/json"])
    }

    func unblock(userID: UUID, accessToken: String) async throws {
        let body = try JSONSerialization.data(withJSONObject: ["blocked_user_id": userID.uuidString])
        _ = try await client.requestData(path: "/rest/v1/rpc/unblock_user", method: "POST", body: body, accessToken: accessToken, headers: ["Content-Type": "application/json"])
    }

    func report(userID: UUID?, dogID: UUID?, category: String, description: String, accessToken: String) async throws {
        let payload: [String: Any] = [
            "reported_user_id": userID?.uuidString ?? NSNull(),
            "reported_dog_id": dogID?.uuidString ?? NSNull(),
            "report_category": category,
            "report_description": description
        ]
        let body = try JSONSerialization.data(withJSONObject: payload)
        _ = try await client.requestData(path: "/rest/v1/rpc/submit_report", method: "POST", body: body, accessToken: accessToken, headers: ["Content-Type": "application/json"])
    }

    func fetchBlockedUsers(accessToken: String) async throws -> [RemoteBlockedUser] {
        try await client.request(
            path: "/rest/v1/rpc/get_blocked_users",
            method: "POST",
            body: Data("{}".utf8),
            accessToken: accessToken,
            responseType: [RemoteBlockedUser].self
        )
    }

    func deleteAccount(accessToken: String) async throws {
        _ = try await client.request(
            path: "/functions/v1/delete-account",
            method: "POST",
            body: Data("{}".utf8),
            accessToken: accessToken,
            responseType: EmptyResponse.self
        )
    }
}
