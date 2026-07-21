import SwiftUI

struct MatchView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    let dog: Dog

    var body: some View {
        VStack(spacing: 26) {
            Spacer()

            HStack(spacing: 22) {
                dogMatchPortrait(store.currentDog)
                dogMatchPortrait(dog)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Match between \(store.currentDog.name) and \(dog.name)")

            VStack(spacing: 10) {
                Text("It’s a match!")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text("\(store.currentDog.name) and \(dog.name) liked each other.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 14) {
                Button("Send a message") {
                    store.selectedTab = .messages
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Keep browsing") {
                    dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.vertical, 24)
        .background(HussleTheme.background.ignoresSafeArea())
    }

    private func dogMatchPortrait(_ dog: Dog) -> some View {
        VStack(spacing: 10) {
            DogThumbnail(dog: dog, size: 132)
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)

            Text(dog.name)
                .font(.headline)
                .foregroundStyle(HussleTheme.text)
                .lineLimit(1)
        }
        .frame(maxWidth: 150)
    }
}
