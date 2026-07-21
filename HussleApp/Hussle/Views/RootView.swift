import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    var body: some View {
        VStack(spacing: 0) {
            ConnectionBanner(
                isConnected: networkMonitor.isConnected,
                message: store.syncError,
                onDismissError: store.dismissError
            )
            Group {
            switch store.launchState {
            case .loading:
                ProgressView("Loading Hussle…").tint(HussleTheme.primary)
            case .authentication:
                AuthView()
            case .onboarding:
                OnboardingView()
            case .main:
                MainTabView()
            }
            }
        }
        .task {
            if store.launchState == .loading { await store.bootstrap() }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        TabView(selection: $store.selectedTab) {
            NavigationStack { DiscoverView() }
                .tabItem { Label("Discover", systemImage: "pawprint.fill") }
                .tag(AppTab.discover)
            NavigationStack { MatchesView() }
                .tabItem { Label("Matches", systemImage: "heart.fill") }
                .tag(AppTab.matches)
            NavigationStack { MessagesView() }
                .tabItem { Label("Messages", systemImage: "message.fill") }
                .tag(AppTab.messages)
            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(AppTab.profile)
        }
        .tint(HussleTheme.primary)
        .task { await store.setupPushNotifications() }
        .onReceive(NotificationCenter.default.publisher(for: .hussleDeviceTokenUpdated)) { _ in
            Task { await store.syncPushRegistration() }
        }
    }
}
