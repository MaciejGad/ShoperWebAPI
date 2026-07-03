import Foundation

public struct Shipping: Decodable, Sendable {
    public let shippingId: Int
    public let active: Bool?
    public let cost: Decimal?
    public let engine: String?
    public let order: Int?
    public let taxId: Int?
    public let isDefault: Bool?
    public let translations: [String: ShippingTranslation]

    public struct ShippingTranslation: Decodable, Sendable {
        public let name: String?
        public let description: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.shippingId = try container.decodeInt(forKey: .shippingId)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.cost = try container.decodeDecimalIfPresent(forKey: .cost)
        self.engine = try container.decodeIfPresent(String.self, forKey: .engine)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.taxId = try container.decodeIntIfPresent(forKey: .taxId)
        self.isDefault = try container.decodeBoolIfPresent(forKey: .isDefault)
        self.translations = (try? container.decode([String: ShippingTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case shippingId
        case active
        case cost
        case engine
        case order
        case taxId
        case isDefault
        case translations
    }
}

extension Shipping: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(shippingId) }
    public static var endpoint: Endpoint { .shippings }
}
