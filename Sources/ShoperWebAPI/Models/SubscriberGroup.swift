import Foundation

public struct SubscriberGroup: Decodable, Sendable {
    public let groupId: Int?
    public let name: String
    public let autoAdd: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupId = try container.decodeIntIfPresent(forKey: .groupId)
        self.name = try container.decode(String.self, forKey: .name)
        self.autoAdd = try container.decodeBoolIfPresent(forKey: .autoAdd)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case groupId
        case name
        case autoAdd
    }
}

extension SubscriberGroup: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateSubscriberGroup
    public typealias UpdatePayload = UpdateSubscriberGroup

    public var id: Identifier { groupId.map { .id($0) } ?? .none }
    public static var endpoint: Endpoint { .subscriberGroups }
}
