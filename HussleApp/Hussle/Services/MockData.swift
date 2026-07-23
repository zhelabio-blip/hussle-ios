import Foundation

struct MockData {
    private static func yearsAgo(_ years: Int) -> Date {
        Calendar.current.date(byAdding: .year, value: -years, to: Date()) ?? Date()
    }

    static let rabies = Vaccination(
        name: "Rabies",
        administeredOn: Calendar.current.date(byAdding: .month, value: -10, to: Date()) ?? Date(),
        validUntil: Calendar.current.date(byAdding: .month, value: 2, to: Date()),
        clinicName: "Da Nang Pet Hospital"
    )

    static let dhpp = Vaccination(
        name: "DHPP",
        administeredOn: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date(),
        validUntil: Calendar.current.date(byAdding: .month, value: 4, to: Date()),
        clinicName: "Da Nang Pet Hospital"
    )

    static let currentDog = Dog(
        id: UUID(),
        name: "Charlie",
        dateOfBirth: yearsAgo(3),
        sex: .male,
        breed: "Chihuahua",
        distanceKm: 0,
        purposes: [.breeding, .walks],
        primaryPurpose: .breeding,
        isTopMatch: false,
        vaccinations: [rabies, dhpp],
        hasHealthInfo: true,
        hasPedigree: true,
        isSterilized: false,
        bio: "Friendly, calm and great with other dogs.",
        ownerName: "Tony",
        city: "Da Nang, Vietnam",
        imageName: "dog-charlie", ownerImageName: "owner-tony",
        activityStatus: "Active today"
    )

    static let dogs: [Dog] = [
        Dog(
            id: UUID(), name: "Luna", dateOfBirth: yearsAgo(3), sex: .female, breed: "Chihuahua", distanceKm: 2.4,
            purposes: [.breeding, .walks], primaryPurpose: .breeding, isTopMatch: true,
            vaccinations: [rabies, dhpp], hasHealthInfo: true, hasPedigree: true, isSterilized: false,
            bio: "Sweet, playful and social. Comfortable around people and other small dogs.",
            ownerName: "Anna", city: "Da Nang, Vietnam", imageName: "dog-luna", ownerImageName: "owner-anna",
            activityStatus: "Active today", recommendationReason: "Same breed · Shared goal: Breeding"
        ),
        Dog(
            id: UUID(), name: "Milo", dateOfBirth: yearsAgo(4), sex: .male, breed: "Poodle", distanceKm: 4.1,
            purposes: [.walks, .friends], primaryPurpose: .walks, isTopMatch: false,
            vaccinations: [rabies, dhpp], hasHealthInfo: true, hasPedigree: false, isSterilized: true,
            bio: "Energetic, affectionate and always ready for a long walk.",
            ownerName: "James", city: "Da Nang, Vietnam", imageName: "dog-milo", ownerImageName: "owner-james",
            activityStatus: "Available this weekend", recommendationReason: "Shared goal: Walks"
        ),
        Dog(
            id: UUID(), name: "Buddy", dateOfBirth: yearsAgo(2), sex: .male, breed: "Dachshund", distanceKm: 6.3,
            purposes: [.friends, .walks], primaryPurpose: .friends, isTopMatch: false,
            vaccinations: [rabies], hasHealthInfo: false, hasPedigree: false, isSterilized: true,
            bio: "Curious, funny and very social with calm dogs.",
            ownerName: "Minh", city: "Da Nang, Vietnam", imageName: "dog-buddy", ownerImageName: "owner-minh",
            activityStatus: "Active today", recommendationReason: "Shared goal: Walks"
        ),
        Dog(
            id: UUID(), name: "Coco", dateOfBirth: yearsAgo(3), sex: .female, breed: "Bichon Frise", distanceKm: 8.7,
            purposes: [.walks, .friends], primaryPurpose: .friends, isTopMatch: false,
            vaccinations: [rabies, dhpp], hasHealthInfo: true, hasPedigree: false, isSterilized: true,
            bio: "Gentle, cheerful and happiest around friendly small dogs.",
            ownerName: "Sophie", city: "Hoi An, Vietnam", imageName: "dog-coco", ownerImageName: "owner-sophie",
            activityStatus: "Active this week", recommendationReason: "Shared goal: Walks"
        ),
        Dog(
            id: UUID(), name: "Zoe", dateOfBirth: yearsAgo(2), sex: .female, breed: "Golden Retriever", distanceKm: 12.0,
            purposes: [.friends], primaryPurpose: .friends, isTopMatch: false,
            vaccinations: [rabies], hasHealthInfo: true, hasPedigree: true, isSterilized: false,
            bio: "Confident, lively and interested in making new dog friends.",
            ownerName: "Emma", city: "Hoi An, Vietnam", imageName: "dog-zoe", ownerImageName: "owner-emma",
            activityStatus: "Active this week", recommendationReason: "Suggested nearby"
        ),
        Dog(
            id: UUID(), name: "Max", dateOfBirth: yearsAgo(3), sex: .male, breed: "French Bulldog", distanceKm: 10.4,
            purposes: [.walks, .friends], primaryPurpose: .walks, isTopMatch: false,
            vaccinations: [rabies, dhpp], hasHealthInfo: true, hasPedigree: false, isSterilized: true,
            bio: "Easygoing, curious and always ready to explore the city.",
            ownerName: "Daniel", city: "Da Nang, Vietnam", imageName: "dog-max", ownerImageName: "owner-daniel",
            activityStatus: "Available this weekend", recommendationReason: "Shared goal: Walks"
        ),
        Dog(
            id: UUID(), name: "Nala", dateOfBirth: yearsAgo(3), sex: .female, breed: "Cavalier King Charles Spaniel", distanceKm: 5.4,
            purposes: [.walks, .friends], primaryPurpose: .walks, isTopMatch: false,
            vaccinations: [rabies, dhpp], hasHealthInfo: true, hasPedigree: true, isSterilized: true,
            bio: "Gentle, affectionate and happiest on relaxed walks with friendly dogs.",
            ownerName: "Olivia", city: "Da Nang, Vietnam", imageName: "dog-nala", ownerImageName: "owner-olivia",
            activityStatus: "Active today", recommendationReason: "Shared goal: Walks"
        )
    ]

    static let messages: [Message] = [
        Message(text: "Hi! Luna is such a sweet girl. We’d love to learn more about Charlie.", isFromCurrentUser: false),
        Message(text: "Hi Anna! Charlie is friendly and great with other dogs. Happy to tell you more.", isFromCurrentUser: true),
        Message(text: "Great! Luna is very social and loves calm walks by the beach.", isFromCurrentUser: false)
    ]
}
