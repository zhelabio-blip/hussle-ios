import SwiftUI

struct DogProfileView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    let dog: Dog
    @State private var showReport = false
    @State private var showBlockConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DogOwnerPortrait(dog: dog, dogSize: 220, ownerSize: 64)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text("\(dog.name), \(dog.age)").font(.largeTitle.bold())
                    Spacer(minLength: 16)
                    Text(dog.primaryPurpose.rawValue)
                        .foregroundStyle(HussleTheme.accent)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(HussleTheme.accent.opacity(0.10))
                        .clipShape(Capsule())
                }
                Text("\(dog.sex.rawValue) · \(dog.breed) · \(dog.distanceKm, specifier: "%.1f") km away")
                    .foregroundStyle(.secondary)
                if !dog.bio.isEmpty { Text(dog.bio).font(.body) }
                infoRow("Vaccinations", subtitle: dog.isVaccinated ? "Details added" : "Not added", icon: "syringe")
                infoRow("Health & breeding", subtitle: dog.hasHealthInfo ? "Health tests and details" : "No information", icon: "cross.case")
                HStack(spacing: 16) {
                    OwnerThumbnail(dog: dog, size: 52)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Owner").font(.headline)
                        Text("\(dog.ownerName) · \(dog.city)").foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.secondary)
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                HStack(spacing: 40) {
                    Button { Task { await store.pass(dog); dismiss() } } label: { CircleButton(icon: "xmark", tint: HussleTheme.primary) }
                    Button { Task { await store.like(dog); dismiss() } } label: { CircleButton(icon: "heart.fill", tint: HussleTheme.accent) }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, HussleTheme.screenPadding)
            .padding(.vertical, 18)
        }
        .background(HussleTheme.background)
        .navigationTitle(dog.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Report profile", systemImage: "exclamationmark.bubble") { showReport = true }
                    Button("Block owner", systemImage: "person.crop.circle.badge.xmark", role: .destructive) { showBlockConfirmation = true }
                } label: { Image(systemName: "ellipsis") }
            }
        }
        .sheet(isPresented: $showReport) { ReportView(dog: dog, ownerID: dog.ownerID) }
        .confirmationDialog("Block \(dog.ownerName)?", isPresented: $showBlockConfirmation, titleVisibility: .visible) {
            Button("Block owner", role: .destructive) {
                Task { if await store.block(ownerID: dog.ownerID, dog: dog) { dismiss() } }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You will no longer see each other’s profiles or be able to communicate.")
        }
    }

    private func infoRow(_ title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon).foregroundStyle(HussleTheme.primary).frame(width: 32)
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.headline)
                Text(subtitle).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(16).background(.white).clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
