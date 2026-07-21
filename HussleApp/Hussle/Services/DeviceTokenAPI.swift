import Foundation

struct DeviceTokenAPI: Sendable {
    private let client = SupabaseRESTClient()

    func register(token: String, preferences: NotificationPreferencesPayload, accessToken: String) async throws {
        let payload = RegisterDeviceTokenPayload(
            token: token,
            platform: "ios",
            matchesEnabled: preferences.matchesEnabled,
            messagesEnabled: preferences.messagesEnabled,
            remindersEnabled: preferences.remindersEnabled,
            productUpdatesEnabled: preferences.productUpdatesEnabled
        )
        let body = try JSONEncoder.supabase.encode(payload)
        _ = try await client.requestData(
            path: "/rest/v1/device_tokens",
            method: "POST",
            queryItems: [URLQueryItem(name: "on_conflict", value: "token")],
            body: body,
            accessToken: accessToken,
            headers: ["Content-Type": "application/json", "Prefer": "resolution=merge-duplicates,return=minimal"]
        )
    }
}

struct NotificationPreferencesPayload: Sendable {
    let matchesEnabled: Bool
    let messagesEnabled: Bool
    let remindersEnabled: Bool
    let productUpdatesEnabled: Bool
}

private struct RegisterDeviceTokenPayload: Encodable {
    let token: String
    let platform: String
    let matchesEnabled: Bool
    let messagesEnabled: Bool
    let remindersEnabled: Bool
    let productUpdatesEnabled: Bool
}
