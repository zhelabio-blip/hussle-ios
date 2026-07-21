import SwiftUI

struct CitySuggestion: Identifiable, Hashable {
    let city: String
    let country: String

    var id: String { displayName }
    var displayName: String { "\(city), \(country)" }
}

final class CitySuggestionStore: ObservableObject {
    static let shared = CitySuggestionStore()

    let allCities: [CitySuggestion] = [
        .init(city: "Da Nang", country: "Vietnam"),
        .init(city: "Hanoi", country: "Vietnam"),
        .init(city: "Ho Chi Minh City", country: "Vietnam"),
        .init(city: "Hoi An", country: "Vietnam"),
        .init(city: "Nha Trang", country: "Vietnam"),
        .init(city: "Bangkok", country: "Thailand"),
        .init(city: "Phuket", country: "Thailand"),
        .init(city: "Chiang Mai", country: "Thailand"),
        .init(city: "Singapore", country: "Singapore"),
        .init(city: "Kuala Lumpur", country: "Malaysia"),
        .init(city: "Bali", country: "Indonesia"),
        .init(city: "Tbilisi", country: "Georgia"),
        .init(city: "Istanbul", country: "Türkiye"),
        .init(city: "Dubai", country: "United Arab Emirates"),
        .init(city: "Abu Dhabi", country: "United Arab Emirates"),
        .init(city: "Paris", country: "France"),
        .init(city: "London", country: "United Kingdom"),
        .init(city: "Berlin", country: "Germany"),
        .init(city: "Barcelona", country: "Spain"),
        .init(city: "Rome", country: "Italy"),
        .init(city: "Lisbon", country: "Portugal"),
        .init(city: "Amsterdam", country: "Netherlands"),
        .init(city: "New York", country: "United States"),
        .init(city: "Los Angeles", country: "United States"),
        .init(city: "Miami", country: "United States"),
        .init(city: "Toronto", country: "Canada"),
        .init(city: "Sydney", country: "Australia"),
        .init(city: "Melbourne", country: "Australia")
    ]

    func matches(for query: String, limit: Int = 6) -> [CitySuggestion] {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return Array(allCities.prefix(limit)) }
        return Array(allCities.filter {
            $0.city.localizedCaseInsensitiveContains(normalized) ||
            $0.country.localizedCaseInsensitiveContains(normalized) ||
            $0.displayName.localizedCaseInsensitiveContains(normalized)
        }.prefix(limit))
    }
}

struct CityAutocompleteField: View {
    @Binding var text: String
    var showError = false
    var title = "City and country"
    var placeholder = "Start typing a city"

    @FocusState private var isFocused: Bool
    @StateObject private var store = CitySuggestionStore.shared

    private var suggestions: [CitySuggestion] {
        guard isFocused else { return [] }
        let exact = store.allCities.contains { $0.displayName.caseInsensitiveCompare(text) == .orderedSame }
        return exact ? [] : store.matches(for: text)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            RequiredFieldLabel(title: title)
            Text("Type a few letters, then choose a city from the suggestions.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(HussleTheme.primary)
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit { isFocused = false }
                if !text.isEmpty {
                    Button {
                        text = ""
                        isFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear city")
                }
            }
            .requiredFieldBorder(showError: showError)

            if !suggestions.isEmpty {
                VStack(spacing: 0) {
                    ForEach(suggestions) { suggestion in
                        Button {
                            text = suggestion.displayName
                            isFocused = false
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(HussleTheme.primary)
                                    .frame(width: 22)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(suggestion.city)
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(HussleTheme.text)
                                    Text(suggestion.country)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 11)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if suggestion.id != suggestions.last?.id {
                            Divider().padding(.leading, 48)
                        }
                    }
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.16), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.07), radius: 12, y: 5)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.16), value: suggestions)
    }
}
