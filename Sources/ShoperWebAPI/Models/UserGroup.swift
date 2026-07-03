import Foundation

public struct UserGroup: Decodable, Sendable {
    public let groupId: Int?
    public let name: String
    public let discount: Decimal?
    /// Pricing level, 1-3.
    public let priceLevel: Int?
    public let autoAdd: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupId = try container.decodeIntIfPresent(forKey: .groupId)
        self.name = try container.decode(String.self, forKey: .name)
        self.discount = try container.decodeDecimalIfPresent(forKey: .discount)
        self.priceLevel = try container.decodeIntIfPresent(forKey: .priceLevel)
        self.autoAdd = try container.decodeBoolIfPresent(forKey: .autoAdd)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case groupId
        case name
        case discount
        case priceLevel
        case autoAdd
    }
}

extension UserGroup: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateUserGroup
    public typealias UpdatePayload = UpdateUserGroup

    public var id: Identifier { groupId.map { .id($0) } ?? .none }
    public static var endpoint: Endpoint { .userGroups }
}
