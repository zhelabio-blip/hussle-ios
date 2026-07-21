import SwiftUI
import UIKit

struct ReportView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    let dog: Dog
    let ownerID: UUID?

    private let categories = [
        "Fake profile", "Incorrect dog information", "Suspected animal abuse", "Irresponsible breeding",
        "Harassment", "Scam or solicitation", "Inappropriate content", "Threatening behavior", "Underage user", "Other"
    ]

    @State private var category = "Fake profile"
    @State private var details = ""
    @State private var submitted = false
    @State private var attemptedSubmit = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    FormGuidanceBanner(text: "Choose a reason. Add details when they can help our moderators understand the issue.")
                }
                Section("Reason") {
                    RequiredFieldLabel(title: "Reason")
                    Picker("Reason", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0).tag($0) }
                    }
                }
                Section("Details") {
                    TextField(category == "Other" ? "Describe what happened (required)" : "Tell us what happened (optional)", text: $details, axis: .vertical)
                        .lineLimit(4...8)
                    if attemptedSubmit && category == "Other" && details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        InlineValidationMessage(text: "Add details when Other is selected.")
                    }
                }
                Section {
                    Button { submit() } label: {
                        if store.isPerformingSafetyAction { ProgressView() } else { Text("Submit report") }
                    }
                    .disabled(store.isPerformingSafetyAction)
                } footer: {
                    Text("Reports are reviewed by Hussle moderators. The other owner will not be told who submitted the report.")
                }
            }
            .navigationTitle("Report profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
            .alert("Report submitted", isPresented: $submitted) {
                Button("Done") { dismiss() }
            } message: {
                Text("Thank you for helping keep Hussle safe.")
            }
        }
    }

    private func submit() {
        if category == "Other" && details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            attemptedSubmit = true
            UIAccessibility.post(notification: .announcement, argument: "Add details when Other is selected.")
            return
        }
        attemptedSubmit = false
        Task {
            if await store.report(dog: dog, ownerID: ownerID, category: category, description: details) {
                submitted = true
            }
        }
    }
}
