import Foundation

public struct CreateLoyaltyEvent: Encodable, Sendable {
    public var userId: Int
    /// Points to award (or subtract, if negative) for this event.
    public var score: Int
    public var note: String?

    public init(userId: Int, score: Int, note: String? = nil) {
        self.userId = userId
        self.score = score
        self.note = note
    }
}
