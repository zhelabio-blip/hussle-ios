import Foundation

struct AuthSession: Codable, Sendable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let expiresAt: Int?
    let user: AuthUser

    var shouldRefresh: Bool {
        guard let expiresAt else { return false }
        return Date().timeIntervalSince1970 >= Double(expiresAt - 60)
    }
}

struct AuthUser: Codable, Sendable {
    let id: UUID
    let email: String?
}

struct SignUpResponse: Codable, Sendable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    let expiresAt: Int?
    let user: AuthUser

    var session: AuthSession? {
        guard let accessToken, let refreshToken, let expiresIn else { return nil }
        return AuthSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: expiresIn,
            expiresAt: expiresAt,
            user: user
        )
    }
}

enum SignUpOutcome: Sendable {
    case authenticated(AuthSession)
    case emailConfirmationRequired(email: String?)
}

struct RemoteProfile: Codable, Identifiable, Sendable {
    let id: UUID
    var firstName: String
    var city: String
    var country: String
    var bio: String
    var latitude: Double?
    var longitude: Double?
}

struct RemoteDog: Codable, Identifiable, Sendable {
    let id: UUID
    let ownerId: UUID
    var name: String
    var breed: String
    var sex: String
    var dateOfBirth: Date
    var primaryPurpose: String
    var purposes: [String]
    var city: String
    var bio: String
    var distanceKm: Double?
    var hasHealthInfo: Bool
    var hasPedigree: Bool
    var isSterilized: Bool
    var isActive: Bool?
}

struct RemoteDogPhoto: Codable, Identifiable, Sendable {
    let id: UUID
    let dogId: UUID
    let storagePath: String
    let sortOrder: Int
    let moderationStatus: String?
}

struct NewRemoteDogPhoto: Encodable, Sendable {
    let dogId: UUID
    let storagePath: String
    let sortOrder: Int
}

struct RemoteVaccination: Codable, Identifiable, Sendable {
    let id: UUID
    let dogId: UUID
    var name: String
    var administeredOn: Date
    var validUntil: Date?
    var clinicName: String
    var documentPath: String?
}

extension RemoteDog {
    init(local dog: Dog, ownerID: UUID) {
        id = dog.id
        ownerId = ownerID
        name = dog.name
        breed = dog.breed
        sex = dog.sex.rawValue.lowercased()
        dateOfBirth = dog.dateOfBirth
        primaryPurpose = dog.primaryPurpose.rawValue.lowercased()
        purposes = dog.purposes.map { $0.rawValue.lowercased() }
        city = dog.city
        bio = dog.bio
        distanceKm = dog.distanceKm
        hasHealthInfo = dog.hasHealthInfo
        hasPedigree = dog.hasPedigree
        isSterilized = dog.isSterilized
        isActive = true
    }

    func localDog(ownerName: String, vaccinations: [Vaccination] = [], photos: [Data] = []) -> Dog {
        Dog(
            id: id,
            name: name,
            dateOfBirth: dateOfBirth,
            sex: Dog.Sex(rawValue: sex.capitalized) ?? .male,
            breed: breed,
            distanceKm: distanceKm ?? 0,
            purposes: purposes.compactMap { Dog.Purpose(rawValue: $0.capitalized) },
            primaryPurpose: Dog.Purpose(rawValue: primaryPurpose.capitalized) ?? .friends,
            isTopMatch: false,
            vaccinations: vaccinations,
            hasHealthInfo: hasHealthInfo,
            hasPedigree: hasPedigree,
            isSterilized: isSterilized,
            bio: bio,
            ownerName: ownerName,
            city: city,
            imageName: "pawprint.fill",
            photoData: photos,
            ownerID: ownerId
        )
    }
}

extension RemoteVaccination {
    init(local vaccination: Vaccination, dogID: UUID) {
        id = vaccination.id
        dogId = dogID
        name = vaccination.name
        administeredOn = vaccination.administeredOn
        validUntil = vaccination.validUntil
        clinicName = vaccination.clinicName
        documentPath = nil
    }

    var local: Vaccination {
        Vaccination(id: id, name: name, administeredOn: administeredOn, validUntil: validUntil, clinicName: clinicName)
    }
}


struct SwipeResult: Codable, Sendable {
    let matched: Bool
    let matchId: UUID?
}

struct RemoteMatchSummary: Codable, Identifiable, Sendable {
    let id: UUID
    let conversationId: UUID
    let matchedAt: Date
    let otherDogId: UUID
    let otherOwnerId: UUID
    let otherOwnerName: String
    let dogName: String
    let breed: String
    let sex: String
    let dateOfBirth: Date
    let primaryPurpose: String
    let purposes: [String]
    let city: String
    let bio: String
    let hasHealthInfo: Bool
    let hasPedigree: Bool
    let isSterilized: Bool
    let lastMessage: String?
    let lastMessageAt: Date?

    func localSummary() -> MatchSummary {
        let dog = Dog(
            id: otherDogId,
            name: dogName,
            dateOfBirth: dateOfBirth,
            sex: Dog.Sex(rawValue: sex.capitalized) ?? .male,
            breed: breed,
            distanceKm: 0,
            purposes: purposes.compactMap { Dog.Purpose(rawValue: $0.capitalized) },
            primaryPurpose: Dog.Purpose(rawValue: primaryPurpose.capitalized) ?? .friends,
            isTopMatch: false,
            vaccinations: [],
            hasHealthInfo: hasHealthInfo,
            hasPedigree: hasPedigree,
            isSterilized: isSterilized,
            bio: bio,
            ownerName: otherOwnerName,
            city: city,
            imageName: "pawprint.fill",
            ownerID: otherOwnerId
        )
        return MatchSummary(
            id: id,
            conversationID: conversationId,
            dog: dog,
            otherOwnerID: otherOwnerId,
            matchedAt: matchedAt,
            lastMessage: lastMessage,
            lastMessageAt: lastMessageAt
        )
    }
}

struct RemoteChatMessage: Codable, Identifiable, Sendable {
    let id: UUID
    let conversationId: UUID
    let senderId: UUID
    let body: String
    let createdAt: Date

    func localMessage(currentUserID: UUID) -> Message {
        Message(
            id: id,
            conversationID: conversationId,
            senderID: senderId,
            text: body,
            isFromCurrentUser: senderId == currentUserID,
            createdAt: createdAt
        )
    }
}

struct SendMessageResult: Codable, Sendable {
    let id: UUID
    let createdAt: Date
}

struct RemoteBlockedUser: Codable, Identifiable, Sendable {
    let id: UUID
    let firstName: String
    let dogName: String?
    let blockedAt: Date
}
