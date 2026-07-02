import Foundation

public struct Unit: Decodable, Sendable {
    public let unitId: Int
    public let floatingPoint: Bool
    public let translations: [String: UnitTranslation]

    public struct UnitTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.unitId = try container.decodeInt(forKey: .unitId)
        self.floatingPoint = try container.decodeBool(forKey: .floatingPoint)
        self.translations = (try? container.decode([String: UnitTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case unitId
        case floatingPoint
        case translations
    }
}

extension Unit: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(unitId) }
    public static var endpoint: Endpoint { .units }
}
