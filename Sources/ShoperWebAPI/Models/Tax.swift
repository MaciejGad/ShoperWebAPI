import Foundation

public struct Tax: Decodable, Sendable {
    public let taxId: Int
    public let name: String
    public let taxClass: String?
    public let value: Decimal

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.taxId = try container.decodeInt(forKey: .taxId)
        self.name = try container.decode(String.self, forKey: .name)
        self.taxClass = try container.decodeIfPresent(String.self, forKey: .taxClass)
        self.value = try container.decodeDecimal(forKey: .value)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    // "class" is a Swift reserved word, so the property is named `taxClass`.
    enum CodingKeys: String, CodingKey {
        case taxId
        case name
        case taxClass = "class"
        case value
    }
}

extension Tax: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(taxId) }
    public static var endpoint: Endpoint { .taxes }
}
