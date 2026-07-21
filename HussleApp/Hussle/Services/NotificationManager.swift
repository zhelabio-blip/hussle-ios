import Foundation
import UIKit
import UserNotifications

@MainActor
final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published private(set) var deviceToken: String?
    @Published var matchesEnabled: Bool { didSet { persist() } }
    @Published var messagesEnabled: Bool { didSet { persist() } }
    @Published var remindersEnabled: Bool { didSet { persist() } }
    @Published var productUpdatesEnabled: Bool { didSet { persist() } }

    private override init() {
        let defaults = UserDefaults.standard
        matchesEnabled = defaults.object(forKey: "notifications.matches") as? Bool ?? true
        messagesEnabled = defaults.object(forKey: "notifications.messages") as? Bool ?? true
        remindersEnabled = defaults.object(forKey: "notifications.reminders") as? Bool ?? false
        productUpdatesEnabled = defaults.object(forKey: "notifications.productUpdates") as? Bool ?? false
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func refreshStatus() async {
        authorizationStatus = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    func requestPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await refreshStatus()
            if granted { UIApplication.shared.registerForRemoteNotifications() }
        } catch {
            await refreshStatus()
        }
    }

    func registerIfAuthorized() async {
        await refreshStatus()
        if authorizationStatus == .authorized || authorizationStatus == .provisional {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func didRegister(deviceToken data: Data) {
        deviceToken = data.map { String(format: "%02x", $0) }.joined()
        NotificationCenter.default.post(name: .hussleDeviceTokenUpdated, object: deviceToken)
    }

    func didFailToRegister(error: Error) {
        print("APNs registration failed: \(error.localizedDescription)")
    }

    private func persist() {
        let defaults = UserDefaults.standard
        defaults.set(matchesEnabled, forKey: "notifications.matches")
        defaults.set(messagesEnabled, forKey: "notifications.messages")
        defaults.set(remindersEnabled, forKey: "notifications.reminders")
        defaults.set(productUpdatesEnabled, forKey: "notifications.productUpdates")
        NotificationCenter.default.post(name: .hussleNotificationPreferencesUpdated, object: nil)
    }

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }
}

extension Notification.Name {
    static let hussleDeviceTokenUpdated = Notification.Name("hussleDeviceTokenUpdated")
    static let hussleNotificationPreferencesUpdated = Notification.Name("hussleNotificationPreferencesUpdated")
}
