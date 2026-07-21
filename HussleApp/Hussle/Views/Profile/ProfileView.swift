import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            Section {
                HStack(alignment: .center, spacing: 22) {
                    DogOwnerPortrait(dog: store.currentDog, dogSize: 96, ownerSize: 40)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(store.currentDog.name)
                            .font(.title2.bold())

                        Text("\(store.currentDog.breed) · \(store.currentDog.age) y.o.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(store.currentDog.purposes) { purpose in
                                Text(purpose.rawValue)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(purpose == .breeding ? HussleTheme.accent : HussleTheme.primary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background((purpose == .breeding ? HussleTheme.accent : HussleTheme.primary).opacity(0.10))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 14)
            }

            Section("Profile") {
                NavigationLink { DogEditorView(dog: store.currentDog) } label: { Label("Edit dog profile", systemImage: "pencil") }
                NavigationLink { VaccinationsEditorView(vaccinations: $store.currentDog.vaccinations) } label: { Label("Vaccinations", systemImage: "syringe") }
                NavigationLink { DiscoverySettingsView() } label: { Label("Discovery preferences", systemImage: "slider.horizontal.3") }
                NavigationLink { NotificationSettingsView() } label: { Label("Notifications", systemImage: "bell") }
            }
            Section("Safety & privacy") {
                NavigationLink { BlockedUsersView() } label: { Label("Blocked users", systemImage: "person.crop.circle.badge.xmark") }
                NavigationLink { SafetyTipsView() } label: { Label("Safety tips", systemImage: "shield") }
                NavigationLink { DeleteAccountView() } label: { Label("Delete account", systemImage: "trash").foregroundStyle(.red) }
            }
            Section("Account") {
                Button("Log Out", role: .destructive) { Task { await store.signOut() } }
            }
        }
        .navigationTitle("Profile")
        .alert("Something went wrong", isPresented: Binding(get: { store.syncError != nil }, set: { if !$0 { store.syncError = nil } })) {
            Button("OK") { store.syncError = nil }
        } message: { Text(store.syncError ?? "Unknown error") }
    }
}

struct SafetyTipsView: View {
    var body: some View {
        List {
            Label("Meet in a public place", systemImage: "mappin.and.ellipse")
            Label("Do not share your home address immediately", systemImage: "house")
            Label("Review vaccination and health records", systemImage: "syringe")
            Label("Consult a veterinarian before breeding", systemImage: "cross.case")
            Label("Never send money under pressure", systemImage: "creditcard")
            Label("Report suspicious or harmful behavior", systemImage: "exclamationmark.shield")
        }
        .navigationTitle("Safety tips")
    }
}
