import SwiftUI

struct BlockedUsersView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            if store.blockedUsers.isEmpty {
                ContentUnavailableView("No blocked users", systemImage: "person.crop.circle.badge.checkmark")
            } else {
                ForEach(store.blockedUsers) { user in
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(user.firstName).font(.headline)
                            if let dogName = user.dogName { Text(dogName).foregroundStyle(.secondary) }
                        }
                        Spacer()
                        Button("Unblock") { Task { await store.unblock(userID: user.id) } }
                            .buttonStyle(.bordered)
                    }
                }
            }
        }
        .navigationTitle("Blocked users")
        .task { await store.refreshBlockedUsers() }
        .refreshable { await store.refreshBlockedUsers() }
    }
}
