import Foundation

/// Note: `additionalFields` (custom registration fields) is not modeled — it's a complex nested
/// structure not needed for typical product-management use cases.
public struct User: Decodable, Sendable {
    public let userId: Int
    public let email: String
    public let firstname: String?
    public let lastname: String?
    public let active: Bool?
    public let comment: String?
    public let discount: Decimal?
    public let groupId: Int?
    public let langId: Int?
    /// List of tags assigned to this user.
    public let tags: [String]?
    public let dateAdd: String?
    public let lastvisit: String?
    public let newsletter: Bool?
    /// 0 - shop, 1 - Facebook, 2 - mobile, 3 - Allegro.
    public let origin: Int?
    /// Is this a registered (account-based) customer, as opposed to a guest?
    public let registered: Bool?
    public let verifyEmail: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decodeInt(forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.discount = try container.decodeDecimalIfPresent(forKey: .discount)
        self.groupId = try container.decodeIntIfPresent(forKey: .groupId)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
        self.dateAdd = try container.decodeDateStringIfPresent(forKey: .dateAdd)
        self.lastvisit = try container.decodeDateStringIfPresent(forKey: .lastvisit)
        self.newsletter = try container.decodeBoolIfPresent(forKey: .newsletter)
        self.origin = try container.decodeIntIfPresent(forKey: .origin)
        self.registered = try container.decodeBoolIfPresent(forKey: .registered)
        self.verifyEmail = try container.decodeBoolIfPresent(forKey: .verifyEmail)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case userId
        case email
        case firstname
        case lastname
        case active
        case comment
        case discount
        case groupId
        case langId
        case tags
        case dateAdd
        case lastvisit
        case newsletter
        case origin
        case registered
        case verifyEmail
    }
}

extension User: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateUser
    public typealias UpdatePayload = UpdateUser

    public var id: Identifier { .id(userId) }
    public static var endpoint: Endpoint { .users }
}
