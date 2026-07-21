import SwiftUI
import UIKit

struct DeleteAccountView: View {
    @EnvironmentObject private var store: AppStore
    @State private var confirmation = ""
    @State private var showFinalConfirmation = false
    @State private var attemptedDelete = false

    var body: some View {
        Form {
            Section {
                Text("Deleting your account permanently removes your owner profile, dog profiles, photos, vaccination records, matches and messages.")
                Text("This action cannot be undone.").fontWeight(.semibold).foregroundStyle(.red)
            }
            Section("Confirm deletion") {
                RequiredFieldLabel(title: "Confirmation")
                Text("Type DELETE exactly as shown below.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                TextField("DELETE", text: $confirmation)
                    .textInputAutocapitalization(.characters)
                if attemptedDelete && confirmation != "DELETE" {
                    InlineValidationMessage(text: "Type DELETE exactly to continue.")
                }
                Button("Permanently delete account", role: .destructive) {
                    guard confirmation == "DELETE" else {
                        attemptedDelete = true
                        UIAccessibility.post(notification: .announcement, argument: "Type DELETE exactly to continue.")
                        return
                    }
                    showFinalConfirmation = true
                }
                .disabled(store.isDeletingAccount)
            }
        }
        .navigationTitle("Delete account")
        .confirmationDialog("Delete your Hussle account?", isPresented: $showFinalConfirmation, titleVisibility: .visible) {
            Button("Delete account", role: .destructive) { Task { await store.deleteAccount() } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your account and associated content will be permanently removed.")
        }
    }
}
