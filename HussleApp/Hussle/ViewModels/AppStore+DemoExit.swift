import Foundation

extension AppStore {
    @MainActor
    func exitDemoMode() async {
        guard isDemoMode else { return }

        selectedDog = nil
        showMatch = false
        selectedTab = .discover
        activeConversationID = nil

        await signOut()

        discoveryPreferences = DiscoveryPreferences()
        manualCity = MockData.currentDog.city
        syncError = nil
        isLoadingMessages = false
        isSendingMessage = false
        isAuthenticating = false
        isSyncing = false
        isRecordingSwipe = false
        isPerformingSafetyAction = false
        isDeletingAccount = false
    }
}
