import Foundation

public struct Language: Decodable, Sendable {
    public let langId: Int
    /// Locale code in `language_REGION` format (e.g. "pl_PL").
    public let locale: String?
    public let active: Bool?
    public let currencyId: Int?
    public let order: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.langId = try container.decodeInt(forKey: .langId)
        self.locale = try container.decodeIfPresent(String.self, forKey: .locale)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.order = try container.decodeIntIfPresent(forKey: .order)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case langId
        case locale
        case active
        case currencyId
        case order
    }
}

extension Language: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    // Creating a language isn't exposed here: POST /languages consistently returned HTTP 500
    // "Internal server error" when verified live (sklep173975.shoparena.pl, 2026-07-03), tried
    // with both a minimal and a full payload, and with two different locale values. GET/list and
    // update work fine, so only create is disabled.
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = UpdateLanguage

    public var id: Identifier { .id(langId) }
    public static var endpoint: Endpoint { .languages }
}
