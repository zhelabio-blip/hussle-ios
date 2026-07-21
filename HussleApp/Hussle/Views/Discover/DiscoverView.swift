import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ZStack {
            HussleTheme.background.ignoresSafeArea()
            VStack(spacing: HussleTheme.contentSpacing) {
                header
                if let dog = store.rankedDogs().first {
                    NavigationLink(value: dog) {
                        DogCard(dog: dog)
                    }
                    .buttonStyle(.plain)
                    actionButtons(for: dog)
                } else {
                    emptyState
                }
                Spacer(minLength: 4)
            }
            .padding(.horizontal, HussleTheme.screenPadding)
            .navigationDestination(for: Dog.self) { dog in
                DogProfileView(dog: dog)
            }
        }
        .sheet(isPresented: $store.showMatch) {
            if let dog = store.selectedDog { MatchView(dog: dog) }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(store.currentDog.name).font(.headline)
                Text("\(store.currentDog.breed) · \(store.currentDog.age) y.o.").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("Hussle").font(.title.bold()).foregroundStyle(HussleTheme.primary).accessibilityIdentifier("discoverTitle")
            Spacer()
            NavigationLink { DiscoverySettingsView() } label: { Image(systemName: "slider.horizontal.3").font(.title3) }
        }
        .padding(.vertical, 6)
    }

    private func actionButtons(for dog: Dog) -> some View {
        HStack(spacing: 36) {
            Button { Task { await store.pass(dog) } } label: { CircleButton(icon: "xmark", tint: HussleTheme.primary) }
                .accessibilityLabel("Pass \(dog.name)")
                .accessibilityIdentifier("passButton")
            NavigationLink(value: dog) { CircleButton(icon: "info", tint: .secondary) }
                .accessibilityLabel("View \(dog.name) profile")
                .accessibilityIdentifier("profileInfoButton")
            Button { Task { await store.like(dog) } } label: { CircleButton(icon: "heart.fill", tint: HussleTheme.accent) }
                .accessibilityLabel("Like \(dog.name)")
                .accessibilityIdentifier("likeButton")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "location.magnifyingglass").font(.system(size: 58)).foregroundStyle(HussleTheme.primary)
            Text("No more perfect matches nearby").font(.title2.bold())
            Text("Try expanding your radius or adding another connection goal.")
                .multilineTextAlignment(.center).foregroundStyle(.secondary)
            Button("Expand search") { store.expandSearch() }
                .accessibilityIdentifier("expandSearchButton")
                .buttonStyle(PrimaryButtonStyle())
            Spacer()
        }
        .padding()
    }
}

struct DogCard: View {
    let dog: Dog

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .topLeading) {
                DogOwnerPortrait(dog: dog, dogSize: 214, ownerSize: 62)
                    .frame(maxWidth: .infinity)

                if dog.isTopMatch {
                    Label("Top match", systemImage: "star.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 7)
                        .background(.black.opacity(0.62))
                        .clipShape(Capsule())
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("\(dog.name), \(dog.age)")
                        .font(.title.bold())
                    Spacer(minLength: 8)
                    Text(dog.primaryPurpose.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(HussleTheme.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(HussleTheme.accent.opacity(0.10))
                        .clipShape(Capsule())
                }

                Text("\(dog.sex.rawValue) · \(dog.breed)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 14) {
                    Label("\(dog.distanceKm, specifier: "%.1f") km", systemImage: "mappin.and.ellipse")
                    Label(dog.ownerName, systemImage: "person.fill")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    StatusPill(text: "Vaccinated", active: dog.isVaccinated)
                    StatusPill(text: "Health", active: dog.hasHealthInfo)
                    StatusPill(text: "Pedigree", active: dog.hasPedigree)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(22)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: HussleTheme.radius, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 16, y: 7)
    }
}

struct StatusPill: View {
    let text: String; let active: Bool
    var body: some View { Text(text).font(.caption.bold()).padding(.horizontal, 10).padding(.vertical, 8).background(active ? HussleTheme.primary.opacity(0.1) : Color.gray.opacity(0.1)).clipShape(Capsule()) }
}

struct CircleButton: View {
    let icon: String; let tint: Color
    var body: some View { Image(systemName: icon).font(.title2.bold()).foregroundStyle(tint).frame(width: 72, height: 72).background(.white).clipShape(Circle()).shadow(color: .black.opacity(0.09), radius: 12, y: 5) }
}
