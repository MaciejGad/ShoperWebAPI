import Foundation

public struct Subscriber: Decodable, Sendable {
    public let subscriberId: Int
    public let email: String
    public let active: Bool?
    public let langId: Int?
    /// Read-only list of subscriber group IDs this subscriber belongs to.
    public let groups: [Int]?
    /// Addition date. Note: the wire key is "dateadd" (no underscore), unlike most other
    /// timestamp fields in the API which use "date_add".
    public let dateAdd: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subscriberId = try container.decodeInt(forKey: .subscriberId)
        self.email = try container.decode(String.self, forKey: .email)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.groups = try container.decodeIntArrayIfPresent(forKey: .groups)
        self.dateAdd = try container.decodeDateStringIfPresent(forKey: .dateAdd)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion. "dateadd" has no underscore,
    // so convertFromSnakeCase leaves it unchanged.
    enum CodingKeys: String, CodingKey {
        case subscriberId
        case email
        case active
        case langId
        case groups
        case dateAdd = "dateadd"
    }
}

extension Subscriber: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateSubscriber
    public typealias UpdatePayload = UpdateSubscriber

    public var id: Identifier { .id(subscriberId) }
    public static var endpoint: Endpoint { .subscribers }
}
