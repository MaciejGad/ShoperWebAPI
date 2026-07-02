import Foundation

public struct AttributeGroup: Decodable, Sendable {
    public let attributeGroupId: Int
    public let name: String
    public let langId: Int
    public let active: Bool?
    public let filters: Bool?
    public let categories: [Int]?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attributeGroupId = try container.decodeInt(forKey: .attributeGroupId)
        self.name = try container.decode(String.self, forKey: .name)
        self.langId = try container.decodeInt(forKey: .langId)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.filters = try container.decodeBoolIfPresent(forKey: .filters)
        self.categories = try container.decodeIfPresent([Int].self, forKey: .categories)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case attributeGroupId
        case name
        case langId
        case active
        case filters
        case categories
    }
}

extension AttributeGroup: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(attributeGroupId) }
    public static var endpoint: Endpoint { .attributeGroups }
}
