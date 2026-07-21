import SwiftUI

struct MatchesView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            if store.matchSummaries.isEmpty {
                ContentUnavailableView(
                    "No matches yet",
                    systemImage: "heart",
                    description: Text("Keep discovering dogs nearby.")
                )
            } else {
                Section("Your matches") {
                    ForEach(store.matchSummaries) { match in
                        NavigationLink {
                            ChatView(match: match)
                        } label: {
                            MatchRow(match: match)
                        }
                    }
                }
            }
        }
        .navigationTitle("Matches")
        .refreshable { await store.refreshMatches() }
        .task { await store.refreshMatches() }
    }
}

private struct MatchRow: View {
    let match: MatchSummary

    var body: some View {
        HStack(spacing: 20) {
            DogOwnerPortrait(dog: match.dog, dogSize: 66, ownerSize: 28)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(match.dog.name), \(match.dog.age)").font(.headline)
                    Spacer()
                    Text(match.activityDate, style: .relative).font(.caption2).foregroundStyle(.secondary)
                }
                Text("\(match.dog.ownerName) · \(match.dog.primaryPurpose.rawValue)")
                    .font(.subheadline)
                    .foregroundStyle(HussleTheme.accent)
                Text(match.lastMessage ?? "You matched — say hello!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 6)
    }
}
