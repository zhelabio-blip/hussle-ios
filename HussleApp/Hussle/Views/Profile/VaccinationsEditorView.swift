import SwiftUI
import UIKit

struct VaccinationsEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var vaccinations: [Vaccination]
    @State private var showAdd = false

    var body: some View {
        List {
            Section {
                FormGuidanceBanner(text: "At least one vaccination record is required for an active profile.")
            }
            if vaccinations.isEmpty {
                ContentUnavailableView("No vaccination records", systemImage: "syringe", description: Text("Tap Add vaccination below to continue."))
                Button("Add vaccination") { showAdd = true }
                    .buttonStyle(PrimaryButtonStyle())
                    .listRowBackground(Color.clear)
            }
            ForEach(vaccinations) { vaccination in
                VStack(alignment: .leading, spacing: 6) {
                    Text(vaccination.name).font(.headline)
                    Text("Given \(vaccination.administeredOn.formatted(date: .abbreviated, time: .omitted))")
                    if let validUntil = vaccination.validUntil {
                        Text("Valid until \(validUntil.formatted(date: .abbreviated, time: .omitted))").foregroundStyle(.secondary)
                    }
                }.padding(.vertical, 4)
            }
            .onDelete { vaccinations.remove(atOffsets: $0) }
        }
        .navigationTitle("Vaccinations")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Done") { dismiss() } }
            ToolbarItem(placement: .primaryAction) {
                Button { showAdd = true } label: { Label("Add vaccination", systemImage: "plus") }
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationStack { AddVaccinationView { vaccinations.append($0) } }
        }
    }
}

struct AddVaccinationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "Rabies"
    @State private var administeredOn = Date()
    @State private var hasExpiry = true
    @State private var validUntil = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var clinic = ""
    @State private var attemptedSave = false
    let onSave: (Vaccination) -> Void

    var body: some View {
        Form {
            Section {
                FormGuidanceBanner(text: "Fields marked Required must be completed before saving.")
            }
            Section {
                RequiredFieldLabel(title: "Vaccination name")
                TextField("e.g. Rabies", text: $name)
                if attemptedSave && trimmedName.isEmpty { InlineValidationMessage(text: "Enter the vaccination name.") }

                RequiredFieldLabel(title: "Date given")
                DatePicker("Date given", selection: $administeredOn, in: ...Date(), displayedComponents: .date)

                Toggle("Has expiry / next due date", isOn: $hasExpiry)
                if hasExpiry {
                    DatePicker("Valid until", selection: $validUntil, in: administeredOn..., displayedComponents: .date)
                }
                TextField("Clinic or veterinarian (optional)", text: $clinic)
            }
        }
        .navigationTitle("Add vaccination")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
            }
        }
    }

    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    private func save() {
        guard !trimmedName.isEmpty else {
            attemptedSave = true
            UIAccessibility.post(notification: .announcement, argument: "Enter the vaccination name.")
            return
        }
        onSave(Vaccination(name: trimmedName, administeredOn: administeredOn, validUntil: hasExpiry ? validUntil : nil, clinicName: clinic))
        dismiss()
    }
}
