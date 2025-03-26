import Foundation

public struct ProductFilterKey: FilterKey {
    public let rawValue: String

    public enum Translation: String {
        /// translation identifier
        case translationId = "translation_id"
        /// product identifier
        case productId = "product_id"
        /// product name
        case name = "name"
        /// short product description
        case shortDescription = "short_description"
        /// product description
        case description = "description"
        /// is product translation active
        case active = "active"
        /// is product added during the install
        case isDefault = "isdefault"
        /// language identifier
        case langId = "lang_id"
        /// title displayed in <title> tag
        case seoTitle = "seo_title"
        /// description displayed in meta description tag
        case seoDescription = "seo_description"
        /// keywords displayed in meta keywords tag
        case seoKeywords = "seo_keywords"
        /// slug displayed in URL
        case seoUrl = "seo_url"
        /// full, direct URL to the product
        case permalink = "permalink"
        /// priority used to calculate upon product list sorting
        case order = "order"
    }
    
    public enum Stock: String {
        /// stock identifier
        case stockId = "stock_id"
        /// product identifier
        case productId = "product_id"
        /// if enabled, object stock is extended by options group; if disabled: basic stock
        case extended = "extended"
        /// a price or its difference to the basic stock price (always greater than 0)
        case price = "price"
        /// is stock active?
        case active = "active"
        /// should the stock be selected as default upon selection?
        case isDefault = "default"
        /// stock availability - if warehouses is enabled field is read only and includes the sum of all warehouses
        case stock = "stock"
        /// if warehouses is enabled it represents stock availability (keys: warehouse identifiers, values: quantity value)
        case warehouses = "warehouses"
        /// a stock difference the shop value should be altered. If present, stock is ignored
        case stockRelative = "stock_relative"
        /// stock availability warning level
        case warnLevel = "warn_level"
        /// sold items count
        case sold = "sold"
        /// a sold items difference the shop value should be altered. If present, sold is ignored
        case soldRelative = "sold_relative"
        /// stock code
        case code = "code"
        /// stock EAN code
        case ean = "ean"
        /// weight
        case weight = "weight"
        /// a method of weight calculation:
        /// 0 - no weight specified,
        /// 1 - a new stock weight,
        /// 2 - weight will be added to the base weight,
        /// 3 - weight will be subtracted from the base weight
        case weightType = "weight_type"
        /// stock availability identifier
        case availabilityId = "availability_id"
        /// stock availability identifier
        case calculatedAvailabilityId = "calculated_availability_id"
        /// stock delivery identifier
        case deliveryId = "delivery_id"
        /// an identifier of product stock photo
        case gfxId = "gfx_id"
        /// package
        case package = "package"
        /// wholesale price first basic stock type
        case priceWholesale = "price_wholesale"
        /// wholesale price second basic stock type
        case priceSpecial = "price_special"
        /// unit price calculation identifier
        case calculationUnitId = "calculation_unit_id"
        /// unit price calculation ratio
        case calculationUnitRatio = "calculation_unit_ratio"
        /// price from the last 30 days before the promotion
        case historicalLowestPrice = "historical_lowest_price"
        /// wholesale price first from the last 30 days before the promotion
        case wholesaleHistoricalLowestPrice = "wholesale_historical_lowest_price"
        /// wholesale price second from the last 30 days before the promotion
        case specialHistoricalLowestPrice = "special_historical_lowest_price"
        /// additional codes
        case additionalCodes = "additional_codes"

    }
    
    public static func translate(_ type: Translation, language: String) -> ProductFilterKey {
        return ProductFilterKey(rawValue: "translation.\(language).\(type.rawValue)")
    }
    
    public static func stock(_ type: Stock) -> ProductFilterKey {
        return ProductFilterKey(rawValue: "stock.\(type.rawValue)")
    }
}

extension Filter where Key == ProductFilterKey {
    public static func name(_ name: String, language: String = "pl_PL") -> Filter<Key> {
        .init(key: .translate(.name, language: language), value: .like("%\(name)%"))
    }
    
    public static func stock(greaterThan value: Int) -> Filter<Key> {
        .init(key: .stock(.stock), value: .greaterThan(value))
    }
    
    public static func stock(lessThan value: Int) -> Filter<Key> {
        .init(key: .stock(.stock), value: .lessThan(value))
    }
}
