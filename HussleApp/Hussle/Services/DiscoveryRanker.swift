import Foundation

struct DiscoveryRanker {
    func rankedDogs(
        candidates: [Dog],
        currentDog: Dog,
        preferences: DiscoveryPreferences
    ) -> [Dog] {
        candidates
            .filter { $0.id != currentDog.id }
            .filter { $0.distanceKm <= preferences.radiusKm }
            .filter {
                preferences.showOtherBreeds ||
                $0.breed.caseInsensitiveCompare(currentDog.breed) == .orderedSame
            }
            .sorted { lhs, rhs in
                let left = score(lhs, currentDog: currentDog)
                let right = score(rhs, currentDog: currentDog)
                if left != right { return left > right }
                if lhs.distanceKm != rhs.distanceKm { return lhs.distanceKm < rhs.distanceKm }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    func score(_ candidate: Dog, currentDog: Dog) -> Int {
        let sameBreed = candidate.breed.caseInsensitiveCompare(currentDog.breed) == .orderedSame
        let samePurpose = !Set(candidate.purposes).isDisjoint(with: Set(currentDog.purposes))

        switch (sameBreed, samePurpose) {
        case (true, true): return 400
        case (true, false): return 300
        case (false, true): return 200
        case (false, false): return 100
        }
    }
}
