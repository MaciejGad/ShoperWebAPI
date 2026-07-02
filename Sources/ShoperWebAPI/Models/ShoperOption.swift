import Foundation

/// A product option (e.g. size, color) — named `ShoperOption` to avoid confusion with Swift's `Optional`.
public struct ShoperOption: Decodable, Sendable {
    public let optionId: Int
    public let groupId: Int?
    public let type: String?
    public let order: Int?
    public let required: Bool?
    public let filters: Bool?
    public let stock: Bool?
    public let changePriceType: Int?
    public let changePriceValue: Decimal?
    public let percent: Bool?
    public let translations: [String: OptionTranslation]

    public struct OptionTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.optionId = try container.decodeInt(forKey: .optionId)
        self.groupId = try container.decodeIntIfPresent(forKey: .groupId)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.required = try container.decodeBoolIfPresent(forKey: .required)
        self.filters = try container.decodeBoolIfPresent(forKey: .filters)
        self.stock = try container.decodeBoolIfPresent(forKey: .stock)
        self.changePriceType = try container.decodeIntIfPresent(forKey: .changePriceType)
        self.changePriceValue = try container.decodeDecimalIfPresent(forKey: .changePriceValue)
        self.percent = try container.decodeBoolIfPresent(forKey: .percent)
        self.translations = (try? container.decode([String: OptionTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case optionId
        case groupId
        case type
        case order
        case required
        case filters
        case stock
        case changePriceType
        case changePriceValue
        case percent
        case translations
    }
}

extension ShoperOption: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(optionId) }
    public static var endpoint: Endpoint { .options }
}
