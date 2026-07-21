import XCTest
@testable import Hussle

final class DiscoveryRankerTests: XCTestCase {
    private let ranker = DiscoveryRanker()

    func testRanksBreedAndPurposeBeforeBreedOnlyAndPurposeOnly() {
        let current = dog(name: "Current", breed: "Chihuahua", purposes: [.breeding], distance: 0)
        let exact = dog(name: "Exact", breed: "Chihuahua", purposes: [.breeding], distance: 20)
        let breedOnly = dog(name: "Breed", breed: "Chihuahua", purposes: [.walks], distance: 1)
        let purposeOnly = dog(name: "Purpose", breed: "Poodle", purposes: [.breeding], distance: 1)
        let other = dog(name: "Other", breed: "Poodle", purposes: [.friends], distance: 0.5)

        let result = ranker.rankedDogs(
            candidates: [other, purposeOnly, breedOnly, exact],
            currentDog: current,
            preferences: DiscoveryPreferences(radiusKm: 50, purposes: [.breeding], sameBreedFirst: true, showOtherBreeds: true)
        )

        XCTAssertEqual(result.map(\.name), ["Exact", "Breed", "Purpose", "Other"])
    }

    func testUsesDistanceInsideSamePriorityTier() {
        let current = dog(name: "Current", breed: "Chihuahua", purposes: [.walks], distance: 0)
        let farther = dog(name: "Farther", breed: "Chihuahua", purposes: [.walks], distance: 10)
        let nearer = dog(name: "Nearer", breed: "Chihuahua", purposes: [.walks], distance: 2)

        let result = ranker.rankedDogs(
            candidates: [farther, nearer],
            currentDog: current,
            preferences: DiscoveryPreferences(radiusKm: 25, purposes: [.walks], sameBreedFirst: true, showOtherBreeds: true)
        )

        XCTAssertEqual(result.map(\.name), ["Nearer", "Farther"])
    }

    func testFiltersOutsideRadiusAndOtherBreedsWhenDisabled() {
        let current = dog(name: "Current", breed: "Chihuahua", purposes: [.friends], distance: 0)
        let valid = dog(name: "Valid", breed: "Chihuahua", purposes: [.friends], distance: 5)
        let tooFar = dog(name: "Far", breed: "Chihuahua", purposes: [.friends], distance: 30)
        let otherBreed = dog(name: "Other", breed: "Poodle", purposes: [.friends], distance: 2)

        let result = ranker.rankedDogs(
            candidates: [otherBreed, tooFar, valid],
            currentDog: current,
            preferences: DiscoveryPreferences(radiusKm: 10, purposes: [.friends], sameBreedFirst: true, showOtherBreeds: false)
        )

        XCTAssertEqual(result.map(\.name), ["Valid"])
    }

    private func dog(name: String, breed: String, purposes: [Dog.Purpose], distance: Double) -> Dog {
        Dog(
            id: UUID(), name: name,
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
            sex: .female, breed: breed, distanceKm: distance,
            purposes: purposes, primaryPurpose: purposes[0], isTopMatch: false,
            vaccinations: [], hasHealthInfo: false, hasPedigree: false,
            isSterilized: false, bio: "", ownerName: "Owner", city: "Da Nang", imageName: ""
        )
    }
}
