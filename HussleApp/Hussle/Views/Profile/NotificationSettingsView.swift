import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @EnvironmentObject private var store: AppStore
    @ObservedObject private var manager = NotificationManager.shared

    var body: some View {
        Form {
            Section {
                statusRow
                if manager.authorizationStatus == .notDetermined {
                    Button("Enable notifications") { Task { await manager.requestPermission(); await store.syncPushRegistration() } }
                } else if manager.authorizationStatus == .denied {
                    Button("Open iOS Settings") { openSettings() }
                }
            } footer: {
                Text("Hussle asks for notification access only here or after a meaningful action such as a match.")
            }

            Section("Notify me about") {
                Toggle("New matches", isOn: $manager.matchesEnabled)
                Toggle("Messages", isOn: $manager.messagesEnabled)
                Toggle("Vaccination reminders", isOn: $manager.remindersEnabled)
                Toggle("Product updates", isOn: $manager.productUpdatesEnabled)
            }
            .disabled(manager.authorizationStatus == .denied)
        }
        .navigationTitle("Notifications")
        .task { await manager.refreshStatus() }
        .onChange(of: manager.matchesEnabled) { _, _ in Task { await store.syncPushRegistration() } }
        .onChange(of: manager.messagesEnabled) { _, _ in Task { await store.syncPushRegistration() } }
        .onChange(of: manager.remindersEnabled) { _, _ in Task { await store.syncPushRegistration() } }
        .onChange(of: manager.productUpdatesEnabled) { _, _ in Task { await store.syncPushRegistration() } }
    }

    private var statusRow: some View {
        HStack {
            Label("System permission", systemImage: "bell.badge")
            Spacer()
            Text(statusText).foregroundStyle(.secondary)
        }
    }

    private var statusText: String {
        switch manager.authorizationStatus {
        case .authorized: "On"
        case .provisional: "Provisional"
        case .denied: "Off"
        case .notDetermined: "Not requested"
        case .ephemeral: "Temporary"
        @unknown default: "Unknown"
        }
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
