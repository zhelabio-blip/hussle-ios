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
}
