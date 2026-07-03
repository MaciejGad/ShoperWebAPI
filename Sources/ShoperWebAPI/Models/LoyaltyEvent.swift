import Foundation

/// A loyalty program event (points awarded/spent) for a user.
///
/// Note: the API only documents `list`/`get`/`create` for this resource — no update or delete
/// endpoint exists (`/loyalty-events/{id}` only has `GET`). `UpdatePayload` is `EmptyPayload`
/// accordingly; calling `LoyaltyEvent.update(...)` will fail against the real API.
public struct LoyaltyEvent: Decodable, Sendable {
    public let eventId: Int
    public let userId: Int?
    /// Points awarded (or subtracted, if negative) by this event.
    public let score: Int?
    /// Cumulative points balance after this event.
    public let sum: Int?
    public let note: String?
    public let date: String?
    public let eventType: Int?
    public let expiredDate: Int?
    public let objectId: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventId = try container.decodeInt(forKey: .eventId)
        self.userId = try container.decodeIntIfPresent(forKey: .userId)
        self.score = try container.decodeIntIfPresent(forKey: .score)
        self.sum = try container.decodeIntIfPresent(forKey: .sum)
        self.note = try container.decodeIfPresent(String.self, forKey: .note)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.eventType = try container.decodeIntIfPresent(forKey: .eventType)
        self.expiredDate = try container.decodeIntIfPresent(forKey: .expiredDate)
        self.objectId = try container.decodeIntIfPresent(forKey: .objectId)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case eventId
        case userId
        case score
        case sum
        case note
        case date
        case eventType
        case expiredDate
        case objectId
    }
}

extension LoyaltyEvent: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateLoyaltyEvent
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(eventId) }
    public static var endpoint: Endpoint { .loyaltyEvents }
}
