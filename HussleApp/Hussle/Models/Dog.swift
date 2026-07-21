import Foundation

struct Vaccination: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var administeredOn: Date
    var validUntil: Date?
    var clinicName: String = ""
}

struct Dog: Identifiable, Hashable {
    var id: UUID
    var name: String
    var dateOfBirth: Date
    var sex: Sex
    var breed: String
    var distanceKm: Double
    var purposes: [Purpose]
    var primaryPurpose: Purpose
    var isTopMatch: Bool
    var vaccinations: [Vaccination]
    var hasHealthInfo: Bool
    var hasPedigree: Bool
    var isSterilized: Bool
    var bio: String
    var ownerName: String
    var city: String
    var imageName: String
    var ownerImageName: String = ""
    var photoData: [Data] = []
    var ownerPhotoData: Data? = nil
    var ownerID: UUID? = nil

    var age: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }

    var isVaccinated: Bool { !vaccinations.isEmpty }

    enum Sex: String, CaseIterable, Identifiable {
        case male = "Male"
        case female = "Female"
        var id: String { rawValue }
    }

    enum Purpose: String, CaseIterable, Hashable, Identifiable {
        case breeding = "Breeding"
        case walks = "Walks"
        case friends = "Friends"
        var id: String { rawValue }
    }
}

struct DiscoveryPreferences: Hashable {
    var radiusKm: Double = 25
    var purposes: Set<Dog.Purpose> = [.breeding]
    var sameBreedFirst = true
    var showOtherBreeds = true
}
