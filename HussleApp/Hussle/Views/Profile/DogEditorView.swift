import PhotosUI
import SwiftUI
import UIKit

struct DogEditorView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var dog: Dog
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showVaccinations = false
    @State private var isSaving = false
    @State private var saveError: String?
    @State private var attemptedSave = false

    private let breeds = ["Chihuahua", "Poodle", "Dachshund", "Golden Retriever", "Labrador Retriever", "French Bulldog", "German Shepherd", "Yorkshire Terrier", "Mixed Breed", "Other"]

    init(dog: Dog) { _dog = State(initialValue: dog) }

    var body: some View {
        Form {
            Section {
                FormGuidanceBanner(text: "Fields marked Required must be completed before the profile can be saved.")
            }

            Section {
                RequiredFieldLabel(title: "Photos")
                photoGrid
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 6, matching: .images) {
                    Label("Add photos", systemImage: "photo.badge.plus")
                }
                if attemptedSave && !hasPhoto {
                    InlineValidationMessage(text: "Add at least one photo.")
                }
                Text("New photos are reviewed before they appear to other users.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .onChange(of: selectedItems) { _, items in Task { await load(items) } }
            }

            Section("Basic information") {
                RequiredFieldLabel(title: "Dog’s name")
                TextField("Dog’s name", text: $dog.name)
                if attemptedSave && trimmed(dog.name).isEmpty { InlineValidationMessage(text: "Enter your dog’s name.") }

                RequiredFieldLabel(title: "Breed")
                Picker("Breed", selection: $dog.breed) { ForEach(breeds, id: \.self) { Text($0).tag($0) } }

                RequiredFieldLabel(title: "Sex")
                Picker("Sex", selection: $dog.sex) { ForEach(Dog.Sex.allCases) { Text($0.rawValue).tag($0) } }

                RequiredFieldLabel(title: "Date of birth")
                DatePicker("Date of birth", selection: $dog.dateOfBirth, in: ...Date(), displayedComponents: .date)
                Toggle("Sterilized", isOn: $dog.isSterilized)
            }

            Section("Looking for") {
                Text("Choose one, two, or all three goals.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                ForEach(Dog.Purpose.allCases) { purpose in
                    Toggle(purpose.rawValue, isOn: purposeBinding(purpose))
                }
                if attemptedSave && dog.purposes.isEmpty { InlineValidationMessage(text: "Select at least one goal.") }
            }

            Section("Health and breeding") {
                RequiredFieldLabel(title: "Vaccinations")
                Button { showVaccinations = true } label: {
                    HStack {
                        Label(dog.vaccinations.isEmpty ? "Add vaccination record" : "Vaccination records", systemImage: "syringe")
                        Spacer()
                        Text("\(dog.vaccinations.count)").foregroundStyle(.secondary)
                    }
                }
                if attemptedSave && dog.vaccinations.isEmpty { InlineValidationMessage(text: "Add at least one vaccination record.") }
                Toggle("Health tests available", isOn: $dog.hasHealthInfo)
                Toggle("Pedigree available", isOn: $dog.hasPedigree)
            }

            Section("About") {
                TextField("Tell other owners about your dog (optional)", text: $dog.bio, axis: .vertical).lineLimit(4...8)
                CityAutocompleteField(
                    text: $dog.city,
                    showError: attemptedSave && trimmed(dog.city).isEmpty
                )
                if attemptedSave && trimmed(dog.city).isEmpty { InlineValidationMessage(text: "Choose a city from the suggestions.") }
            }

            if attemptedSave, let validationMessage {
                Section {
                    InlineValidationMessage(text: validationMessage)
                }
            }
        }
        .navigationTitle("Edit dog profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button(isSaving ? "Saving…" : "Save") { save() }
                    .disabled(isSaving)
            }
        }
        .alert("Couldn’t save changes", isPresented: Binding(get: { saveError != nil }, set: { if !$0 { saveError = nil } })) {
            Button("OK", role: .cancel) { saveError = nil }
        } message: { Text(saveError ?? "") }
        .sheet(isPresented: $showVaccinations) {
            NavigationStack { VaccinationsEditorView(vaccinations: $dog.vaccinations) }
        }
    }

    private var photoGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(dog.photoData.enumerated()), id: \.offset) { index, data in
                    if let image = UIImage(data: data) {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image).resizable().scaledToFill().frame(width: 96, height: 96).clipped().clipShape(RoundedRectangle(cornerRadius: 16))
                            Button { dog.photoData.remove(at: index) } label: {
                                Image(systemName: "xmark.circle.fill").foregroundStyle(.white, .black.opacity(0.55))
                            }.padding(6)
                        }
                    }
                }
                if dog.photoData.isEmpty {
                    if let image = UIImage(named: dog.imageName) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill((attemptedSave && !hasPhoto ? Color.red : HussleTheme.primary).opacity(0.08))
                            .frame(width: 96, height: 96)
                            .overlay(Image(systemName: "photo").foregroundStyle(attemptedSave && !hasPhoto ? .red : HussleTheme.primary))
                    }
                }
            }
        }
    }

    private var hasPhoto: Bool { !dog.photoData.isEmpty || !dog.imageName.isEmpty }

    private var validationMessage: String? {
        if !hasPhoto { return "Add at least one photo before saving." }
        if trimmed(dog.name).isEmpty { return "Enter your dog’s name before saving." }
        if dog.purposes.isEmpty { return "Select at least one goal before saving." }
        if dog.vaccinations.isEmpty { return "Add at least one vaccination record before saving." }
        if trimmed(dog.city).isEmpty { return "Choose a city before saving." }
        return nil
    }

    private func purposeBinding(_ purpose: Dog.Purpose) -> Binding<Bool> {
        Binding {
            dog.purposes.contains(purpose)
        } set: { enabled in
            if enabled {
                if !dog.purposes.contains(purpose) { dog.purposes.append(purpose) }
            } else {
                dog.purposes.removeAll { $0 == purpose }
            }
            if let first = dog.purposes.first { dog.primaryPurpose = first }
        }
    }

    private func save() {
        guard validationMessage == nil else {
            attemptedSave = true
            UIAccessibility.post(notification: .announcement, argument: validationMessage)
            return
        }
        attemptedSave = false
        if !dog.purposes.contains(dog.primaryPurpose), let first = dog.purposes.first { dog.primaryPurpose = first }
        Task {
            isSaving = true
            let saved = await store.saveDogAndSync(dog)
            isSaving = false
            if saved { dismiss() } else { saveError = store.syncError ?? "Unable to save this profile." }
        }
    }

    private func load(_ items: [PhotosPickerItem]) async {
        var loaded: [Data] = []
        for item in items.prefix(6) {
            if let data = try? await item.loadTransferable(type: Data.self) { loaded.append(data) }
        }
        if !loaded.isEmpty { dog.photoData = loaded }
    }

    private func trimmed(_ value: String) -> String { value.trimmingCharacters(in: .whitespacesAndNewlines) }
}
