import SwiftUI

@MainActor
final class AppStore: ObservableObject {
    enum LaunchState { case loading, authentication, onboarding, main }

    @Published var launchState: LaunchState = .loading
    @Published var selectedTab: AppTab = .discover
    @Published var currentDog = MockData.currentDog
    @Published var discoveryPreferences = DiscoveryPreferences()
    @Published var discoveryDogs = MockData.dogs
    @Published var matchSummaries: [MatchSummary] = []
    @Published var selectedDog: Dog?
    @Published var showMatch = false
    @Published var messages: [Message] = MockData.messages
    @Published var activeConversationID: UUID?
    @Published var isLoadingMessages = false
    @Published var isSendingMessage = false
    @Published var manualCity = "Da Nang, Vietnam"
    @Published var ownerFirstName = ""
    @Published var authError: String?
    @Published var authNotice: String?
    @Published var syncError: String?
    @Published var isAuthenticating = false
    @Published var isSyncing = false
    @Published var isRecordingSwipe = false
    @Published var blockedUsers: [RemoteBlockedUser] = []
    @Published var isPerformingSafetyAction = false
    @Published var isDeletingAccount = false

    private let configuration = BackendConfiguration.load()
    private let authService = AuthService()
    private let sessionStore = SessionStore()
    private let profileRepository = ProfileRepository()
    private let discoveryAPI = DiscoveryAPI()
    private let swipeAPI = SwipeAPI()
    private let chatAPI = ChatAPI()
    private let safetyAPI = SafetyAPI()
    private let deviceTokenAPI = DeviceTokenAPI()
    private let realtimeChatService = RealtimeChatService()
    private let discoveryRanker = DiscoveryRanker()
    private(set) var session: AuthSession?
    private(set) var demoMode = false

    var isDemoMode: Bool { demoMode }
    var isBackendConfigured: Bool { configuration.isConfigured }
    var hasCompletedOnboarding: Bool { launchState == .main }

    func bootstrap() async {
        if ProcessInfo.processInfo.arguments.contains("UITEST_DEMO") {
            prepareForUITests()
            return
        }
        if ProcessInfo.processInfo.arguments.contains("UITEST_AUTH") {
            launchState = .authentication
            return
        }
        if !configuration.isConfigured {
            launchState = .authentication
            return
        }
        guard let saved = await sessionStore.load() else {
            launchState = .authentication
            return
        }
        session = saved
        do {
            _ = try await validSession()
            await hydrateRemoteAccount()
        } catch {
            await sessionStore.clear()
            session = nil
            authError = "Your session expired. Please log in again."
            launchState = .authentication
        }
    }

    func signUp(email: String, password: String) async {
        authError = nil
        authNotice = nil
        isAuthenticating = true
        defer { isAuthenticating = false }
        do {
            switch try await authService.signUp(email: email, password: password) {
            case let .authenticated(result):
                session = result
                try await sessionStore.save(result)
                await hydrateRemoteAccount()
            case let .emailConfirmationRequired(email):
                let destination = email.map { " at \($0)" } ?? ""
                authNotice = "Check your email\(destination) to confirm your account, then return here and log in."
            }
        } catch {
            authError = readableAuthError(error)
        }
    }

    func signIn(email: String, password: String) async {
        await authenticate { try await authService.signIn(email: email, password: password) }
    }

    private func authenticate(_ operation: () async throws -> AuthSession) async {
        authError = nil
        authNotice = nil
        isAuthenticating = true
        defer { isAuthenticating = false }
        do {
            let result = try await operation()
            session = result
            try await sessionStore.save(result)
            await hydrateRemoteAccount()
        } catch {
            authError = readableAuthError(error)
        }
    }

    private func readableAuthError(_ error: Error) -> String {
        if case let SupabaseRESTClient.ClientError.server(code, body) = error {
            let lower = body.lowercased()
            if code == 400, lower.contains("invalid login credentials") {
                return "The email or password is incorrect."
            }
            if code == 422, lower.contains("already") {
                return "An account with this email may already exist. Try logging in instead."
            }
            return "Authentication failed. Please try again."
        }
        if error is DecodingError {
            return "Hussle received an unexpected authentication response. Please try again."
        }
        return error.localizedDescription
    }

    private func validSession() async throws -> AuthSession {
        guard var active = session else { throw AuthStateError.missingSession }
        if active.shouldRefresh {
            active = try await authService.refresh(refreshToken: active.refreshToken)
            session = active
            try await sessionStore.save(active)
        }
        return active
    }

    func dismissAuthFeedback() {
        authError = nil
        authNotice = nil
    }

    func continueInDemoMode() {
        authError = nil
        authNotice = nil
        syncError = nil
        demoMode = true
        ownerFirstName = ""
        currentDog = MockData.currentDog
        discoveryDogs = MockData.dogs
        matchSummaries = []
        messages = MockData.messages
        activeConversationID = nil
        selectedDog = nil
        showMatch = false
        selectedTab = .discover
        launchState = .onboarding
    }

    func signOut() async {
        await realtimeChatService.disconnect()
        session = nil
        demoMode = false
        authError = nil
        authNotice = nil
        await sessionStore.clear()
        ownerFirstName = ""
        currentDog = MockData.currentDog
        discoveryDogs = MockData.dogs
        matchSummaries = []
        blockedUsers = []
        messages = []
        activeConversationID = nil
        launchState = .authentication
    }

    private func hydrateRemoteAccount() async {
        isSyncing = true
        defer { isSyncing = false }
        do {
            let active = try await validSession()
            let profile = try await profileRepository.loadOwner(userID: active.user.id, token: active.accessToken)
            guard let profile else {
                launchState = .onboarding
                return
            }
            ownerFirstName = profile.firstName
            manualCity = profile.city
            let dogs = try await profileRepository.loadDogs(ownerID: active.user.id, token: active.accessToken)
            if let first = dogs.first {
                async let vaccinationTask = profileRepository.loadVaccinations(dogID: first.id, token: active.accessToken)
                async let photoTask = profileRepository.loadPhotos(dogID: first.id, token: active.accessToken)
                let (vaccinations, photos) = try await (vaccinationTask, photoTask)
                currentDog = first.localDog(ownerName: profile.firstName, vaccinations: vaccinations, photos: photos)
                discoveryPreferences.purposes = Set(currentDog.purposes)
                launchState = .main
                await refreshDiscovery()
                await refreshMatches()
            } else {
                launchState = .onboarding
            }
        } catch {
            syncError = error.localizedDescription
            launchState = .onboarding
        }
    }

    func refreshDiscovery() async {
        guard !demoMode, configuration.isConfigured else {
            discoveryDogs = MockData.dogs
            return
        }
        do {
            let active = try await validSession()
            let remoteDogs = try await discoveryAPI.fetchDogs(
                activeDogId: currentDog.id,
                radiusKm: discoveryPreferences.radiusKm,
                accessToken: active.accessToken
            )
            discoveryDogs = remoteDogs.map {
                $0.localDog(ownerName: "Owner")
            }
        } catch {
            syncError = error.localizedDescription
        }
    }

    func completeOnboarding(dog: Dog, firstName: String, latitude: Double?, longitude: Double?) async {
        saveDog(dog)
        ownerFirstName = firstName.isEmpty ? "Owner" : firstName
        manualCity = dog.city
        guard !demoMode, configuration.isConfigured else {
            launchState = .main
            return
        }

        isSyncing = true
        syncError = nil
        defer { isSyncing = false }
        do {
            let active = try await validSession()
            let profile = RemoteProfile(
                id: active.user.id,
                firstName: ownerFirstName,
                city: dog.city,
                country: "",
                bio: "",
                latitude: latitude,
                longitude: longitude
            )
            _ = try await profileRepository.upsertOwner(profile, token: active.accessToken)
            try await profileRepository.saveCompleteDog(dog, ownerID: active.user.id, token: active.accessToken)
            launchState = .main
            await refreshDiscovery()
        } catch {
            syncError = error.localizedDescription
        }
    }

    func rankedDogs() -> [Dog] {
        discoveryRanker.rankedDogs(
            candidates: discoveryDogs,
            currentDog: currentDog,
            preferences: discoveryPreferences
        )
    }

    func dismissError() {
        syncError = nil
        authError = nil
    }

    func prepareForUITests() {
        demoMode = true
        ownerFirstName = "Tony"
        currentDog = MockData.currentDog
        discoveryDogs = MockData.dogs
        launchState = .main
    }

    func like(_ dog: Dog) async {
        await recordSwipe(dog, action: "like")
    }

    func pass(_ dog: Dog) async {
        await recordSwipe(dog, action: "pass")
    }

    private func recordSwipe(_ dog: Dog, action: String) async {
        guard !isRecordingSwipe else { return }
        isRecordingSwipe = true
        syncError = nil
        defer { isRecordingSwipe = false }

        if demoMode || !configuration.isConfigured {
            applyLocalSwipe(dog, action: action, matched: action == "like" && dog.isTopMatch)
            return
        }

        do {
            let active = try await validSession()
            let result = try await swipeAPI.record(
                sourceDogID: currentDog.id,
                targetDogID: dog.id,
                action: action,
                accessToken: active.accessToken
            )
            applyLocalSwipe(dog, action: action, matched: result.matched)
        } catch {
            syncError = error.localizedDescription
        }
    }

    private func applyLocalSwipe(_ dog: Dog, action: String, matched: Bool) {
        selectedDog = action == "like" ? dog : nil
        if matched {
            if demoMode || !configuration.isConfigured {
                let summary = MatchSummary(id: UUID(), conversationID: UUID(), dog: dog, otherOwnerID: dog.ownerID, matchedAt: Date(), lastMessage: nil, lastMessageAt: nil)
                if !matchSummaries.contains(where: { $0.dog.id == dog.id }) { matchSummaries.insert(summary, at: 0) }
            } else {
                Task { await refreshMatches() }
            }
            showMatch = true
        }
        discoveryDogs.removeAll { $0.id == dog.id }
    }

    func expandSearch() {
        discoveryPreferences.radiusKm = min(discoveryPreferences.radiusKm + 25, 100)
        discoveryPreferences.purposes.formUnion([.walks, .friends])
        if demoMode || !configuration.isConfigured {
            discoveryDogs = MockData.dogs
        } else {
            Task { await refreshDiscovery() }
        }
    }

    func saveDog(_ dog: Dog) {
        currentDog = dog
        discoveryPreferences.purposes = Set(dog.purposes)
    }

    func saveDogAndSync(_ dog: Dog) async -> Bool {
        saveDog(dog)
        guard !demoMode, configuration.isConfigured else { return true }
        isSyncing = true
        syncError = nil
        defer { isSyncing = false }
        do {
            let active = try await validSession()
            try await profileRepository.saveCompleteDog(dog, ownerID: active.user.id, token: active.accessToken)
            await refreshDiscovery()
            return true
        } catch {
            syncError = error.localizedDescription
            return false
        }
    }

    func refreshMatches() async {
        guard !demoMode, configuration.isConfigured else {
            if matchSummaries.isEmpty, let dog = MockData.dogs.first {
                matchSummaries = [MatchSummary(id: UUID(), conversationID: UUID(), dog: dog, otherOwnerID: dog.ownerID, matchedAt: Date(), lastMessage: MockData.messages.last?.text, lastMessageAt: Date())]
            }
            return
        }
        do {
            let active = try await validSession()
            let remote = try await chatAPI.fetchMatches(activeDogID: currentDog.id, accessToken: active.accessToken)
            matchSummaries = remote.map { $0.localSummary() }
        } catch {
            syncError = error.localizedDescription
        }
    }

    func loadConversation(_ conversationID: UUID) async {
        activeConversationID = conversationID
        guard !demoMode, configuration.isConfigured else {
            messages = MockData.messages
            return
        }
        isLoadingMessages = true
        defer { isLoadingMessages = false }
        do {
            let active = try await validSession()
            let remote = try await chatAPI.fetchMessages(conversationID: conversationID, accessToken: active.accessToken)
            messages = remote.map { $0.localMessage(currentUserID: active.user.id) }
        } catch {
            syncError = error.localizedDescription
        }
    }

    func sendMessage(_ text: String, conversationID: UUID) async {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, !isSendingMessage else { return }
        isSendingMessage = true
        defer { isSendingMessage = false }

        if demoMode || !configuration.isConfigured {
            messages.append(Message(conversationID: conversationID, text: clean, isFromCurrentUser: true))
            return
        }

        do {
            let active = try await validSession()
            _ = try await chatAPI.sendMessage(conversationID: conversationID, body: clean, accessToken: active.accessToken)
            await loadConversation(conversationID)
            await refreshMatches()
        } catch {
            syncError = error.localizedDescription
        }
    }

    func unmatch(_ match: MatchSummary) async -> Bool {
        guard !isPerformingSafetyAction else { return false }
        isPerformingSafetyAction = true
        syncError = nil
        defer { isPerformingSafetyAction = false }
        if demoMode || !configuration.isConfigured {
            matchSummaries.removeAll { $0.id == match.id }
            return true
        }
        do {
            let active = try await validSession()
            try await safetyAPI.unmatch(matchID: match.id, accessToken: active.accessToken)
            matchSummaries.removeAll { $0.id == match.id }
            if activeConversationID == match.conversationID {
                activeConversationID = nil
                messages = []
            }
            return true
        } catch {
            syncError = error.localizedDescription
            return false
        }
    }

    func block(ownerID: UUID?, dog: Dog? = nil) async -> Bool {
        guard !isPerformingSafetyAction else { return false }
        isPerformingSafetyAction = true
        syncError = nil
        defer { isPerformingSafetyAction = false }
        if demoMode || !configuration.isConfigured {
            if let dog {
                discoveryDogs.removeAll { $0.id == dog.id }
                matchSummaries.removeAll { $0.dog.id == dog.id }
            }
            return true
        }
        do {
            guard let ownerID else { throw SafetyStateError.missingOwner }
            let active = try await validSession()
            try await safetyAPI.block(userID: ownerID, accessToken: active.accessToken)
            if let dog {
                discoveryDogs.removeAll { $0.id == dog.id }
                matchSummaries.removeAll { $0.dog.id == dog.id }
            }
            await refreshBlockedUsers()
            await refreshDiscovery()
            await refreshMatches()
            return true
        } catch {
            syncError = error.localizedDescription
            return false
        }
    }

    func report(dog: Dog, ownerID: UUID?, category: String, description: String) async -> Bool {
        guard !isPerformingSafetyAction else { return false }
        isPerformingSafetyAction = true
        syncError = nil
        defer { isPerformingSafetyAction = false }
        if demoMode || !configuration.isConfigured { return true }
        do {
            let active = try await validSession()
            try await safetyAPI.report(userID: ownerID, dogID: dog.id, category: category, description: description, accessToken: active.accessToken)
            return true
        } catch {
            syncError = error.localizedDescription
            return false
        }
    }

    func refreshBlockedUsers() async {
        guard !demoMode, configuration.isConfigured else { return }
        do {
            let active = try await validSession()
            blockedUsers = try await safetyAPI.fetchBlockedUsers(accessToken: active.accessToken)
        } catch {
            syncError = error.localizedDescription
        }
    }

    func unblock(userID: UUID) async {
        guard !isPerformingSafetyAction else { return }
        isPerformingSafetyAction = true
        defer { isPerformingSafetyAction = false }
        do {
            let active = try await validSession()
            try await safetyAPI.unblock(userID: userID, accessToken: active.accessToken)
            blockedUsers.removeAll { $0.id == userID }
            await refreshDiscovery()
        } catch {
            syncError = error.localizedDescription
        }
    }

    func deleteAccount() async {
        guard !isDeletingAccount else { return }
        isDeletingAccount = true
        syncError = nil
        defer { isDeletingAccount = false }
        if demoMode || !configuration.isConfigured {
            await signOut()
            return
        }
        do {
            let active = try await validSession()
            try await safetyAPI.deleteAccount(accessToken: active.accessToken)
            await signOut()
        } catch {
            syncError = error.localizedDescription
        }
    }

    func setupPushNotifications() async {
        await NotificationManager.shared.registerIfAuthorized()
        await syncPushRegistration()
    }

    func syncPushRegistration() async {
        guard !demoMode, configuration.isConfigured, let token = NotificationManager.shared.deviceToken else { return }
        do {
            let active = try await validSession()
            let manager = NotificationManager.shared
            try await deviceTokenAPI.register(
                token: token,
                preferences: NotificationPreferencesPayload(
                    matchesEnabled: manager.matchesEnabled,
                    messagesEnabled: manager.messagesEnabled,
                    remindersEnabled: manager.remindersEnabled,
                    productUpdatesEnabled: manager.productUpdatesEnabled
                ),
                accessToken: active.accessToken
            )
        } catch {
            syncError = error.localizedDescription
        }
    }

    func startRealtimeChat(conversationID: UUID) async {
        guard !demoMode, configuration.isConfigured else { return }
        do {
            let active = try await validSession()
            try await realtimeChatService.connect(
                configuration: configuration,
                accessToken: active.accessToken,
                conversationID: conversationID
            ) { [weak self] in
                guard let self else { return }
                await self.loadConversation(conversationID)
                await self.refreshMatches()
            }
        } catch {
            syncError = error.localizedDescription
        }
    }

    func stopRealtimeChat() async {
        await realtimeChatService.disconnect()
    }

}

enum SafetyStateError: LocalizedError {
    case missingOwner
    var errorDescription: String? { "The owner profile could not be identified." }
}

enum AuthStateError: LocalizedError {
    case missingSession
    var errorDescription: String? { "No active authentication session." }
}

enum AppTab: Hashable { case discover, matches, messages, profile }

private extension Array where Element: Hashable {
    func isDisjoint(with set: Set<Element>) -> Bool { Set(self).isDisjoint(with: set) }
}
