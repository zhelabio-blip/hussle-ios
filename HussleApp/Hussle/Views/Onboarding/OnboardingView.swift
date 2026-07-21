import SwiftUI
import UIKit
import PhotosUI

struct OnboardingView: View {
    @EnvironmentObject private var store: AppStore
    @State private var page = 0
    @State private var draftDog = MockData.currentDog
    @State private var ownerFirstName = ""
    @State private var ownerPhotoItem: PhotosPickerItem?
    @State private var ownerPhotoData: Data?
    @State private var attemptedPages: Set<Int> = []
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            ZStack {
                HussleTheme.background.ignoresSafeArea()
                VStack(spacing: 18) {
                    progress
                    Group {
                        switch page {
                        case 0: welcome
                        case 1: ownerAndGoals
                        case 2: basicDetails
                        case 3: health
                        case 4: location
                        default: preview
                        }
                    }
                    Spacer(minLength: 8)

                    if let message = pageValidationMessage, attemptedPages.contains(page) {
                        InlineValidationMessage(text: message)
                            .padding(.horizontal, HussleTheme.screenPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button(page == 5 ? "Create profile" : page == 0 ? "Get started" : "Continue") {
                        advance()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, HussleTheme.screenPadding)
                    .accessibilityHint(canContinue ? "Moves to the next step" : "Shows what is still required")
                    .accessibilityIdentifier(page == 0 ? "onboardingGetStartedButton" : "onboardingContinueButton")
                }
                .padding(.vertical, 18)
            }
        }
        .onChange(of: ownerPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run { ownerPhotoData = data }
                }
            }
        }
    }

    private var progress: some View {
        HStack(spacing: 12) {
            if page > 0 {
                Button {
                    attemptedPages.remove(page)
                    withAnimation(.easeInOut(duration: 0.2)) {
                        page -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(HussleTheme.primary)
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
                .accessibilityHint("Returns to the previous step without losing your information")
            }

            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    Capsule()
                        .fill(index <= page ? HussleTheme.primary : Color.gray.opacity(0.18))
                        .frame(height: 5)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Step \(page + 1) of 6")
        }
        .padding(.horizontal, 28)
    }

    private var welcome: some View {
        GeometryReader { proxy in
            let portraitSize = min(max(proxy.size.width * 0.52, 176), 224)
            VStack(spacing: 22) {
                Spacer(minLength: 12)

                Text("Hussle")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(HussleTheme.primary)

                DogThumbnail(dog: draftDog, size: portraitSize)
                    .overlay(Circle().stroke(.white, lineWidth: 4))
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 5)

                VStack(spacing: 12) {
                    Text("Meaningful matches for happy dogs")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    Text("Find nearby dogs for breeding, walks, and friendship.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: 430)
                .padding(.horizontal, HussleTheme.screenPadding)

                Spacer(minLength: 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var ownerAndGoals: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Tell us about you").font(.largeTitle.bold())
                FormGuidanceBanner(text: "Fields marked Required must be completed before you can continue.")

                VStack(alignment: .leading, spacing: 12) {
                    RequiredFieldLabel(title: "Your photo")
                    Text("Add a clear photo of yourself so other owners know who they may meet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 18) {
                        OwnerPhotoPreview(data: ownerPhotoData, imageName: ownerPhotoData == nil && store.isDemoMode ? "owner-tony" : "", size: 86)

                        VStack(alignment: .leading, spacing: 10) {
                            PhotosPicker(selection: $ownerPhotoItem, matching: .images) {
                                Label(ownerPhotoData == nil ? "Choose photo" : "Change photo", systemImage: "camera.fill")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .buttonStyle(.bordered)

                            if store.isDemoMode && ownerPhotoData == nil {
                                Button("Use demo photo") {
                                    ownerPhotoData = DemoOwnerPhoto.data(named: "owner-tony")
                                }
                                .font(.subheadline)
                            }
                        }
                    }
                    .padding(14)
                    .background(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(showPageError && ownerPhotoData == nil ? Color.red : HussleTheme.primary.opacity(0.22), lineWidth: 1.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    if showPageError && ownerPhotoData == nil {
                        InlineValidationMessage(text: "Add your photo to continue.")
                    }
                }

                VStack(alignment: .leading, spacing: 7) {
                    RequiredFieldLabel(title: "Your name")
                    Text("This is your name as the dog owner. You’ll add your dog’s name on the next step.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    TextField("e.g. Tony", text: $ownerFirstName)
                        .textContentType(.givenName)
                        .requiredFieldBorder(showError: showPageError && trimmed(ownerFirstName).isEmpty)
                        .accessibilityLabel("Your name, required")
                        .accessibilityHint("Enter the dog owner’s name. Your dog’s name is added on the next step.")
                    if showPageError && trimmed(ownerFirstName).isEmpty {
                        InlineValidationMessage(text: "Enter your name as the dog owner.")
                    }
                }

                VStack(alignment: .leading, spacing: 7) {
                    RequiredFieldLabel(title: "What are you looking for?")
                    Text("Choose one, two, or all three. You can change this later.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    ForEach(Dog.Purpose.allCases) { purpose in
                        purposeCard(purpose)
                    }

                    if showPageError && draftDog.purposes.isEmpty {
                        InlineValidationMessage(text: "Select at least one goal.")
                    }
                }
            }
            .padding()
        }
    }

    private func purposeCard(_ purpose: Dog.Purpose) -> some View {
        let isSelected = draftDog.purposes.contains(purpose)
        return Button {
            if isSelected {
                draftDog.purposes.removeAll { $0 == purpose }
            } else {
                draftDog.purposes.append(purpose)
            }
            if let first = draftDog.purposes.first { draftDog.primaryPurpose = first }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: purpose == .breeding ? "heart.fill" : purpose == .walks ? "figure.walk" : "pawprint.fill")
                    .frame(width: 28)
                    .foregroundStyle(isSelected ? HussleTheme.accent : .primary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(purpose.rawValue).font(.headline)
                    Text(purpose == .breeding ? "Find a suitable partner" : purpose == .walks ? "Meet for local walks" : "Socialize and connect")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? HussleTheme.primary : .secondary)
            }
            .padding()
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? HussleTheme.primary : (showPageError && draftDog.purposes.isEmpty ? Color.red.opacity(0.65) : Color.clear), lineWidth: isSelected ? 2 : 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint("Double tap to toggle this goal")
    }

    private var basicDetails: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tell us about your dog").font(.largeTitle.bold())
                FormGuidanceBanner(text: "Complete the required details below. Optional information can be added later.")

                VStack(alignment: .leading, spacing: 7) {
                    RequiredFieldLabel(title: "Dog’s name")
                    TextField("e.g. Charlie", text: $draftDog.name)
                        .requiredFieldBorder(showError: showPageError && trimmed(draftDog.name).isEmpty)
                    if showPageError && trimmed(draftDog.name).isEmpty { InlineValidationMessage(text: "Enter your dog’s name.") }
                }

                VStack(alignment: .leading, spacing: 7) {
                    RequiredFieldLabel(title: "Breed")
                    Picker("Breed", selection: $draftDog.breed) {
                        ForEach(["Chihuahua", "Poodle", "Dachshund", "Golden Retriever", "Labrador Retriever", "French Bulldog", "Mixed Breed", "Other"], id: \.self) { Text($0).tag($0) }
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                RequiredFieldLabel(title: "Sex")
                Picker("Sex", selection: $draftDog.sex) { ForEach(Dog.Sex.allCases) { Text($0.rawValue).tag($0) } }
                    .pickerStyle(.segmented)

                RequiredFieldLabel(title: "Date of birth")
                DatePicker("Date of birth", selection: $draftDog.dateOfBirth, in: ...Date(), displayedComponents: .date)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 14))

                Toggle("Sterilized", isOn: $draftDog.isSterilized)
                    .padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding()
        }
    }

    private var health: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Health information").font(.largeTitle.bold())
                FormGuidanceBanner(text: "At least one vaccination record is required before discovery can be activated.")
                RequiredFieldLabel(title: "Vaccinations")
                NavigationLink {
                    VaccinationsEditorView(vaccinations: $draftDog.vaccinations)
                } label: {
                    HStack {
                        Label(draftDog.vaccinations.isEmpty ? "Add vaccination record" : "Vaccination records", systemImage: "syringe")
                        Spacer()
                        Text("\(draftDog.vaccinations.count)").foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(showPageError && draftDog.vaccinations.isEmpty ? Color.red : Color.clear, lineWidth: 1.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                if showPageError && draftDog.vaccinations.isEmpty {
                    InlineValidationMessage(text: "Add at least one vaccination record.")
                }
                Toggle("Health tests available", isOn: $draftDog.hasHealthInfo).padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                Toggle("Pedigree available", isOn: $draftDog.hasPedigree).padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                TextField("Short description (optional)", text: $draftDog.bio, axis: .vertical).lineLimit(3...6).textFieldStyle(.roundedBorder)
            }
            .padding()
        }
    }

    private var location: some View {
        ScrollView {
            VStack(spacing: 22) {
                Image(systemName: "location.circle.fill").font(.system(size: 72)).foregroundStyle(HussleTheme.primary)
                Text("Find dogs nearby").font(.largeTitle.bold())
                Text("Hussle uses your approximate location. Your exact location is never shown to other users.")
                    .multilineTextAlignment(.center).foregroundStyle(.secondary)

                RequiredFieldLabel(title: "Location")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(locationManager.coordinate == nil ? "Use my location" : "Location added") {
                    locationManager.requestLocation()
                }
                .buttonStyle(PrimaryButtonStyle())

                Text("or")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                CityAutocompleteField(
                    text: $draftDog.city,
                    showError: showPageError && trimmed(draftDog.city).isEmpty && locationManager.coordinate == nil
                )
                if let error = locationManager.errorMessage {
                    Text(error).font(.caption).foregroundStyle(.red)
                }
                if showPageError && trimmed(draftDog.city).isEmpty && locationManager.coordinate == nil {
                    InlineValidationMessage(text: "Allow location access or choose your city from the suggestions.")
                }

                VStack(alignment: .leading) {
                    Text("Search radius: \(Int(store.discoveryPreferences.radiusKm)) km").font(.headline)
                    Slider(value: $store.discoveryPreferences.radiusKm, in: 5...100, step: 5)
                }.padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
    }

    private var preview: some View {
        GeometryReader { proxy in
            let compact = proxy.size.height < 690
            VStack(spacing: compact ? 12 : 18) {
                Text("Review your profile")
                    .font(compact ? .title.bold() : .largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                DogOwnerPortrait(dog: previewDog, dogSize: compact ? 142 : 170, ownerSize: compact ? 54 : 64)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: compact ? 7 : 10) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(draftDog.name), \(draftDog.age)")
                            .font(compact ? .title2.bold() : .title.bold())
                        Spacer()
                        PurposeChip(purpose: draftDog.primaryPurpose)
                    }
                    Text("\(draftDog.sex.rawValue) · \(draftDog.breed)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Label(draftDog.city, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 8)], alignment: .leading, spacing: 8) {
                        ForEach(draftDog.purposes) { purpose in
                            PurposeChip(purpose: purpose)
                        }
                    }
                    HStack(spacing: 12) {
                        Label("Vaccinated", systemImage: "checkmark.shield.fill")
                        if draftDog.hasHealthInfo { Label("Health info", systemImage: "cross.case.fill") }
                        if draftDog.hasPedigree { Label("Pedigree", systemImage: "rosette") }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    Text("Owner: \(ownerFirstName)")
                        .font(.subheadline.weight(.semibold))
                }
                .padding(compact ? 14 : 18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("You can edit everything later.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    private var previewDog: Dog {
        var dog = draftDog
        dog.ownerName = ownerFirstName
        dog.ownerPhotoData = ownerPhotoData
        if dog.ownerImageName.isEmpty && store.isDemoMode { dog.ownerImageName = "owner-tony" }
        return dog
    }

    private var showPageError: Bool { attemptedPages.contains(page) }

    private var canContinue: Bool {
        switch page {
        case 1: return ownerPhotoData != nil && !trimmed(ownerFirstName).isEmpty && !draftDog.purposes.isEmpty
        case 2: return !trimmed(draftDog.name).isEmpty && !draftDog.breed.isEmpty
        case 3: return !draftDog.vaccinations.isEmpty
        case 4: return !trimmed(draftDog.city).isEmpty || locationManager.coordinate != nil
        default: return true
        }
    }

    private var pageValidationMessage: String? {
        switch page {
        case 1:
            if ownerPhotoData == nil { return "Add your photo to continue." }
            if trimmed(ownerFirstName).isEmpty { return "Enter your name as the dog owner to continue." }
            if draftDog.purposes.isEmpty { return "Select at least one goal to continue." }
        case 2:
            if trimmed(draftDog.name).isEmpty { return "Enter your dog’s name to continue." }
            if draftDog.breed.isEmpty { return "Select your dog’s breed to continue." }
        case 3:
            if draftDog.vaccinations.isEmpty { return "Add at least one vaccination record to continue." }
        case 4:
            if trimmed(draftDog.city).isEmpty && locationManager.coordinate == nil { return "Add your location or enter a city to continue." }
        default: break
        }
        return nil
    }

    private func advance() {
        guard canContinue else {
            attemptedPages.insert(page)
            UIAccessibility.post(notification: .announcement, argument: pageValidationMessage ?? "Complete the required fields.")
            return
        }
        attemptedPages.remove(page)
        if page < 5 { page += 1 }
        else {
            Task {
                var completedDog = draftDog
                completedDog.ownerName = ownerFirstName
                completedDog.ownerPhotoData = ownerPhotoData
                if completedDog.ownerImageName.isEmpty && store.isDemoMode { completedDog.ownerImageName = "owner-tony" }
                await store.completeOnboarding(
                    dog: completedDog,
                    firstName: ownerFirstName,
                    latitude: locationManager.coordinate?.latitude,
                    longitude: locationManager.coordinate?.longitude
                )
            }
        }
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private enum DemoOwnerPhoto {
    static func data(named name: String) -> Data? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: "DemoImages")
                ?? Bundle.main.url(forResource: name, withExtension: "jpg") else { return nil }
        return try? Data(contentsOf: url)
    }
}

private struct OwnerPhotoPreview: View {
    let data: Data?
    let imageName: String
    let size: CGFloat

    var body: some View {
        Group {
            if let data, let image = UIImage(data: data) {
                Image(uiImage: image).resizable().interpolation(.high).antialiased(true).scaledToFill()
            } else if let data = DemoOwnerPhoto.data(named: imageName), let image = UIImage(data: data) {
                Image(uiImage: image).resizable().interpolation(.high).antialiased(true).scaledToFill()
            } else {
                ZStack {
                    HussleTheme.primary.opacity(0.10)
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: size * 0.56))
                        .foregroundStyle(HussleTheme.primary.opacity(0.58))
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(.white, lineWidth: 3))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
}

private struct PurposeChip: View {
    let purpose: Dog.Purpose
    var body: some View {
        Text(purpose.rawValue)
            .font(.caption.weight(.semibold))
            .foregroundStyle(purpose == .breeding ? HussleTheme.accent : HussleTheme.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background((purpose == .breeding ? HussleTheme.accent : HussleTheme.primary).opacity(0.10))
            .clipShape(Capsule())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background {
                if isEnabled {
                    LinearGradient(colors: [HussleTheme.accent, HussleTheme.primary], startPoint: .leading, endPoint: .trailing)
                } else {
                    LinearGradient(colors: [Color.gray.opacity(0.35), Color.gray.opacity(0.35)], startPoint: .leading, endPoint: .trailing)
                }
            }
            .clipShape(Capsule())
            .opacity(configuration.isPressed && isEnabled ? 0.82 : 1)
    }
}
