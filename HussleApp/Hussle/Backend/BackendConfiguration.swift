import Foundation

enum AppEnvironment: String, Sendable {
    case development
    case staging
    case production

    var displayName: String { rawValue.capitalized }
}

struct BackendConfiguration: Sendable {
    let projectURL: URL?
    let anonKey: String
    let environment: AppEnvironment

    var isConfigured: Bool { projectURL != nil && !anonKey.isEmpty }

    static func load(bundle: Bundle = .main) -> BackendConfiguration {
        let rawURL = bundle.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
        let key = bundle.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""
        let rawEnvironment = bundle.object(forInfoDictionaryKey: "APP_ENVIRONMENT") as? String ?? "development"
        return BackendConfiguration(
            projectURL: URL(string: rawURL),
            anonKey: key,
            environment: AppEnvironment(rawValue: rawEnvironment) ?? .development
        )
    }
}
