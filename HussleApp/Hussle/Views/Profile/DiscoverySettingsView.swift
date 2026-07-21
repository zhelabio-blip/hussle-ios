import SwiftUI

struct DiscoverySettingsView: View {
    @EnvironmentObject private var store: AppStore
    @StateObject private var locationManager = LocationManager()
    @State private var goalNotice: String?

    var body: some View {
        Form {
            Section("Distance") {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Up to \(Int(store.discoveryPreferences.radiusKm)) km").font(.headline)
                    Slider(value: $store.discoveryPreferences.radiusKm, in: 5...100, step: 5)
                }
            }
            Section {
                ForEach(Dog.Purpose.allCases) { purpose in
                    Toggle(purpose.rawValue, isOn: Binding {
                        store.discoveryPreferences.purposes.contains(purpose)
                    } set: { enabled in
                        updatePurpose(purpose, enabled: enabled)
                    })
                }
                if let goalNotice {
                    InlineValidationMessage(text: goalNotice)
                }
            } header: {
                Text("Goals")
            } footer: {
                Text("Select at least one goal. Multiple goals can be active at the same time.")
            }
            Section("Matching") {
                Toggle("Prioritize the same breed", isOn: $store.discoveryPreferences.sameBreedFirst)
                Toggle("Show other breeds when needed", isOn: $store.discoveryPreferences.showOtherBreeds)
            }
            Section {
                CityAutocompleteField(text: $store.manualCity)
                Button("Use my current location") { locationManager.requestLocation() }
                if let coordinate = locationManager.coordinate {
                    Label("Location updated", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                    Text("Approximate coordinates: \(coordinate.latitude, specifier: "%.2f"), \(coordinate.longitude, specifier: "%.2f")")
                        .font(.caption).foregroundStyle(.secondary)
                }
                if let error = locationManager.errorMessage { Text(error).font(.caption).foregroundStyle(.red) }
            } header: {
                Text("Location")
            } footer: {
                Text("Enter a city or use your current location so Hussle can calculate distance.")
            }
        }
        .navigationTitle("Discovery preferences")
    }

    private func updatePurpose(_ purpose: Dog.Purpose, enabled: Bool) {
        if enabled {
            store.discoveryPreferences.purposes.insert(purpose)
            goalNotice = nil
        } else if store.discoveryPreferences.purposes.count == 1,
                  store.discoveryPreferences.purposes.contains(purpose) {
            goalNotice = "Keep at least one goal selected."
        } else {
            store.discoveryPreferences.purposes.remove(purpose)
            goalNotice = nil
        }
    }
}
