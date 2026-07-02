import Foundation

public struct OptionValue: Decodable, Sendable {
    public let ovalueId: Int
    public let optionId: Int
    public let order: Int?
    public let color: String?
    /// Denomination amount (gift card variant value). Read-only, only set for denomination options.
    public let amount: Decimal?
    public let changePriceType: Int?
    public let changePriceValue: Decimal?
    public let percent: Bool?
    public let totalProducts: Int?
    public let totalStocks: Int?
    public let translations: [String: OptionValueTranslation]

    public struct OptionValueTranslation: Decodable, Sendable {
        public let value: String?
    }

    public func value(locale: String = "pl_PL") -> String? {
        translations[locale]?.value
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ovalueId = try container.decodeInt(forKey: .ovalueId)
        self.optionId = try container.decodeInt(forKey: .optionId)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.amount = try container.decodeDecimalIfPresent(forKey: .amount)
        self.changePriceType = try container.decodeIntIfPresent(forKey: .changePriceType)
        self.changePriceValue = try container.decodeDecimalIfPresent(forKey: .changePriceValue)
        self.percent = try container.decodeBoolIfPresent(forKey: .percent)
        self.totalProducts = try container.decodeIntIfPresent(forKey: .totalProducts)
        self.totalStocks = try container.decodeIntIfPresent(forKey: .totalStocks)
        self.translations = (try? container.decode([String: OptionValueTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case ovalueId
        case optionId
        case order
        case color
        case amount
        case changePriceType
        case changePriceValue
        case percent
        case totalProducts
        case totalStocks
        case translations
    }
}

extension OptionValue: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(ovalueId) }
    public static var endpoint: Endpoint { .optionValues }
}
