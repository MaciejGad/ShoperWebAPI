import Foundation

/// `GET /application-config` — a singleton resource (no list, no id).
///
/// The full `ApplicationConfig` schema has ~80 fields, mostly blog/comment-moderation settings
/// unrelated to product management. Only the fields most broadly useful for a product-management
/// client are modeled here; unmodeled fields are simply ignored by `Decodable`.
public struct ApplicationConfig: Decodable, Sendable {
    public let shopName: String?
    public let shopUrl: String?
    public let shopEmail: String?
    public let shopPhone: String?
    public let shopCompanyName: String?
    public let shopCountry: String?
    public let defaultCurrencyId: Int?
    public let defaultCurrencyName: String?
    public let defaultLanguageId: Int?
    public let defaultLanguageName: String?
    public let localeTimezone: String?
    public let localeDefaultWeight: String?
    public let warehousesEnabled: Bool?
    public let storefrontEnabled: Bool?
    public let shopOff: Bool?
    public let shoppingOff: Bool?
    public let shoppingPriceLevels: Int?
    public let shoppingPromoCodesEnable: Bool?
    public let loyaltyEnable: Bool?
    /// Only present when the access token has the `shop_license_type` scope.
    /// 1 - basic, 2 - pro, 3 - enterprise.
    public let licenseType: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.shopName = try container.decodeIfPresent(String.self, forKey: .shopName)
        self.shopUrl = try container.decodeIfPresent(String.self, forKey: .shopUrl)
        self.shopEmail = try container.decodeIfPresent(String.self, forKey: .shopEmail)
        self.shopPhone = try container.decodeIfPresent(String.self, forKey: .shopPhone)
        self.shopCompanyName = try container.decodeIfPresent(String.self, forKey: .shopCompanyName)
        self.shopCountry = try container.decodeIfPresent(String.self, forKey: .shopCountry)
        self.defaultCurrencyId = try container.decodeIntIfPresent(forKey: .defaultCurrencyId)
        self.defaultCurrencyName = try container.decodeIfPresent(String.self, forKey: .defaultCurrencyName)
        self.defaultLanguageId = try container.decodeIntIfPresent(forKey: .defaultLanguageId)
        self.defaultLanguageName = try container.decodeIfPresent(String.self, forKey: .defaultLanguageName)
        self.localeTimezone = try container.decodeIfPresent(String.self, forKey: .localeTimezone)
        self.localeDefaultWeight = try container.decodeIfPresent(String.self, forKey: .localeDefaultWeight)
        // Some boolean flags on this endpoint come back as "" (empty string) rather than a
        // proper false/null when unset (observed live: shop_off, shopping_allow_overselling).
        // `try?` + `?? nil` tolerates that by treating any decode failure as absent.
        self.warehousesEnabled = (try? container.decodeBoolIfPresent(forKey: .warehousesEnabled)) ?? nil
        self.storefrontEnabled = (try? container.decodeBoolIfPresent(forKey: .storefrontEnabled)) ?? nil
        self.shopOff = (try? container.decodeBoolIfPresent(forKey: .shopOff)) ?? nil
        self.shoppingOff = (try? container.decodeBoolIfPresent(forKey: .shoppingOff)) ?? nil
        self.shoppingPriceLevels = try container.decodeIntIfPresent(forKey: .shoppingPriceLevels)
        self.shoppingPromoCodesEnable = (try? container.decodeBoolIfPresent(forKey: .shoppingPromoCodesEnable)) ?? nil
        self.loyaltyEnable = (try? container.decodeBoolIfPresent(forKey: .loyaltyEnable)) ?? nil
        self.licenseType = try container.decodeIntIfPresent(forKey: .licenseType)
    }

    enum CodingKeys: CodingKey {
        case shopName
        case shopUrl
        case shopEmail
        case shopPhone
        case shopCompanyName
        case shopCountry
        case defaultCurrencyId
        case defaultCurrencyName
        case defaultLanguageId
        case defaultLanguageName
        case localeTimezone
        case localeDefaultWeight
        case warehousesEnabled
        case storefrontEnabled
        case shopOff
        case shoppingOff
        case shoppingPriceLevels
        case shoppingPromoCodesEnable
        case loyaltyEnable
        case licenseType
    }

    public static func get(client: ClientProtocol) async throws -> ApplicationConfig {
        let data = try await client.get(endpoint: .applicationConfig, id: nil, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }
}
