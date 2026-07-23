import XCTest
@testable import Hussle

final class DogModelTests: XCTestCase {
    func testVaccinatedWhenAtLeastOneRecordExists() {
        var dog = MockData.currentDog
        dog.vaccinations = []
        XCTAssertFalse(dog.isVaccinated)

        dog.vaccinations = [Vaccination(name: "Rabies", administeredOn: Date())]
        XCTAssertTrue(dog.isVaccinated)
    }

    func testAgeUsesCompletedCalendarYears() {
        var dog = MockData.currentDog
        dog.dateOfBirth = Calendar.current.date(byAdding: .year, value: -4, to: Date())!
        XCTAssertEqual(dog.age, 4)
    }

    func testDemoLibraryContainsEightCompleteProfiles() {
        let allDogs = [MockData.currentDog] + MockData.dogs

        XCTAssertEqual(allDogs.count, 8)
        XCTAssertEqual(Set(allDogs.map(\.name)), Set(["Charlie", "Luna", "Milo", "Buddy", "Coco", "Zoe", "Max", "Nala"]))
        XCTAssertEqual(Set(allDogs.map(\.imageName)).count, 8)
        XCTAssertEqual(Set(allDogs.map(\.ownerImageName)).count, 8)
        XCTAssertTrue(allDogs.allSatisfy { !$0.imageName.isEmpty && !$0.ownerImageName.isEmpty })
    }

    func testApprovedDemoBreedAndOwnerMappings() {
        let allDogs = [MockData.currentDog] + MockData.dogs
        let mappings = Dictionary(uniqueKeysWithValues: allDogs.map { ($0.name, ($0.breed, $0.ownerName)) })

        XCTAssertEqual(mappings["Zoe"]?.0, "Golden Retriever")
        XCTAssertEqual(mappings["Zoe"]?.1, "Emma")
        XCTAssertEqual(mappings["Max"]?.0, "French Bulldog")
        XCTAssertEqual(mappings["Max"]?.1, "Daniel")
        XCTAssertEqual(mappings["Nala"]?.0, "Cavalier King Charles Spaniel")
        XCTAssertEqual(mappings["Nala"]?.1, "Olivia")
    }
}
