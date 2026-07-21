import Foundation

actor AuthService {
    private let client: SupabaseRESTClient

    init(client: SupabaseRESTClient = SupabaseRESTClient()) {
        self.client = client
    }

    func signUp(email: String, password: String) async throws -> SignUpOutcome {
        let body = try JSONEncoder().encode(["email": email, "password": password])
        let response = try await client.request(
            path: "/auth/v1/signup",
            method: "POST",
            body: body,
            responseType: SignUpResponse.self
        )
        if let session = response.session {
            return .authenticated(session)
        }
        return .emailConfirmationRequired(email: response.user.email ?? email)
    }

    func signIn(email: String, password: String) async throws -> AuthSession {
        let body = try JSONEncoder().encode(["email": email, "password": password])
        return try await client.request(
            path: "/auth/v1/token",
            method: "POST",
            queryItems: [URLQueryItem(name: "grant_type", value: "password")],
            body: body,
            responseType: AuthSession.self
        )
    }

    func refresh(refreshToken: String) async throws -> AuthSession {
        let body = try JSONEncoder().encode(["refresh_token": refreshToken])
        return try await client.request(
            path: "/auth/v1/token",
            method: "POST",
            queryItems: [URLQueryItem(name: "grant_type", value: "refresh_token")],
            body: body,
            responseType: AuthSession.self
        )
    }
}
