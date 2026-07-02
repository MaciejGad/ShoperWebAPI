import Foundation

public struct OptionGroup: Decodable, Sendable {
    public let groupId: Int?
    public let totalProducts: Int?
    public let totalStocks: Int?
    public let translations: [String: OptionGroupTranslation]

    public struct OptionGroupTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupId = try container.decodeIntIfPresent(forKey: .groupId)
        self.totalProducts = try container.decodeIntIfPresent(forKey: .totalProducts)
        self.totalStocks = try container.decodeIntIfPresent(forKey: .totalStocks)
        self.translations = (try? container.decode([String: OptionGroupTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case groupId
        case totalProducts
        case totalStocks
        case translations
    }
}

extension OptionGroup: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { groupId.map { .id($0) } ?? .none }
    public static var endpoint: Endpoint { .optionGroups }
}
