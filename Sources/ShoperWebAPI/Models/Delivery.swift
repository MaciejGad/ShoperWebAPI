import Foundation

public struct Delivery: Decodable, Sendable {
    public let deliveryId: Int
    public let hours: String?
    public let translations: [String: DeliveryTranslation]

    public struct DeliveryTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deliveryId = try container.decodeInt(forKey: .deliveryId)
        self.hours = try container.decodeIfPresent(String.self, forKey: .hours)
        self.translations = (try? container.decode([String: DeliveryTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case deliveryId
        case hours
        case translations
    }
}

extension Delivery: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(deliveryId) }
    public static var endpoint: Endpoint { .deliveries }
}
