import Foundation

/// Note: unlike most Shoper resources, `Payment`'s wire keys are inconsistently cased —
/// `payment_id`/`translations` are snake_case, but `minAmount`/`maxAmount`/`imageUrl`/
/// `supportedCurrencies` are already camelCase in the raw API response.
public struct Payment: Decodable, Sendable {
    public let paymentId: Int
    public let name: String?
    public let minAmount: Decimal?
    public let maxAmount: Decimal?
    public let imageUrl: String?
    public let order: Int?
    public let currencies: [Int]?
    public let translations: [String: PaymentTranslation]

    public struct PaymentTranslation: Decodable, Sendable {
        public let title: String?
        public let description: String?
        public let active: Bool?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decodeIfPresent(String.self, forKey: .title)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.active = try container.decodeBoolIfPresent(forKey: .active)
        }

        enum CodingKeys: CodingKey {
            case title
            case description
            case active
        }
    }

    public func title(locale: String = "pl_PL") -> String? {
        translations[locale]?.title
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentId = try container.decodeInt(forKey: .paymentId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.minAmount = try container.decodeDecimalIfPresent(forKey: .minAmount)
        self.maxAmount = try container.decodeDecimalIfPresent(forKey: .maxAmount)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.currencies = try container.decodeIntArrayIfPresent(forKey: .currencies)
        self.translations = (try? container.decode([String: PaymentTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion. Since minAmount/maxAmount/
    // imageUrl have no underscores in the wire format, convertFromSnakeCase leaves them unchanged.
    enum CodingKeys: CodingKey {
        case paymentId
        case name
        case minAmount
        case maxAmount
        case imageUrl
        case order
        case currencies
        case translations
    }
}

extension Payment: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(paymentId) }
    public static var endpoint: Endpoint { .payments }
}
