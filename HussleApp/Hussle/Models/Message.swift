import Foundation

struct Message: Identifiable, Hashable, Codable, Sendable {
    var id: UUID
    let conversationID: UUID?
    let senderID: UUID?
    let text: String
    let isFromCurrentUser: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        conversationID: UUID? = nil,
        senderID: UUID? = nil,
        text: String,
        isFromCurrentUser: Bool,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.conversationID = conversationID
        self.senderID = senderID
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
        self.createdAt = createdAt
    }

    var timestamp: String {
        createdAt.formatted(date: .omitted, time: .shortened)
    }
}

struct MatchSummary: Identifiable, Hashable, Sendable {
    let id: UUID
    let conversationID: UUID
    let dog: Dog
    let otherOwnerID: UUID?
    let matchedAt: Date
    let lastMessage: String?
    let lastMessageAt: Date?

    var activityDate: Date { lastMessageAt ?? matchedAt }
}
