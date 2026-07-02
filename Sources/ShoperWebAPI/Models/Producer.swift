import Foundation

public struct Producer: Decodable, Sendable {
    public let producerId: Int
    public let name: String?
    public let gfx: String?
    public let isDefault: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.producerId = try container.decodeInt(forKey: .producerId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.gfx = try container.decodeIfPresent(String.self, forKey: .gfx)
        self.isDefault = try container.decodeBoolIfPresent(forKey: .isDefault)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: String, CodingKey {
        case producerId
        case name
        case gfx
        case isDefault = "isdefault"
    }
}

extension Producer: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(producerId) }
    public static var endpoint: Endpoint { .producers }
}
