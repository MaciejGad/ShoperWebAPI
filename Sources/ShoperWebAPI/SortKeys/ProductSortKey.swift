import Foundation

/// Sort keys available for product queries
public enum ProductSortKey: SortKey {
    /// Product identifier
    case productId
    /// Type of product (0 - product, 1 - bundle)
    case type
    /// Producer identifier
    case producerId
    /// Option group identifier the product is bound to
    case groupId
    /// Tax identifier
    case taxId
    /// Measurement unit identifier
    case unitId
    /// Product addition date
    case addDate
    /// Last product modification date
    case editDate
    /// Price of product in other shops
    case otherPrice
    /// Product package width
    case dimensionW
    /// Product package height
    case dimensionH
    /// Product package length
    case dimensionL
    /// PKWiU (product quantifier)
    case pkwiu
    /// Loyalty points gained upon product buying
    case loyaltyScore
    /// Product price calculated to loyalty points
    case loyaltyPrice
    /// Is loyalty enabled for product?
    case inLoyalty
    /// Is product marked as bestseller?
    case bestseller
    /// Is product marked as new?
    case newproduct
    /// Gauge product weight
    case volWeight
    /// Gauge identifier
    case gaugeId
    /// Product currency identifier
    case currencyId
    /// Stock availability
    case stock
    /// Stock availability identifier
    case stockAvailabilityId
    /// Calculated stock availability identifier
    case stockCalculatedAvailabilityId
    /// Stock delivery identifier
    case stockDeliveryId
    /// Stock price or its difference to the basic stock price
    case stockPrice
    /// Is stock active?
    case stockActive
    /// Should the stock be selected as default upon selection?
    case stockDefault
    /// sold items count
    case stockSold
    /// Stock code
    case stockCode
    /// Stock EAN code
    case stockEan
    /// Stock weight
    case stockWeight
    /// Method of weight calculation (0 - no weight, 1 - new weight, 2 - add to base, 3 - subtract from base)
    case stockWeightType
    /// Wholesale price first basic stock type
    case stockPriceWholesale
    /// Wholesale price second basic stock type
    case stockPriceSpecial
    /// Product translations
    case translations
    /// Translation identifier for specific locale
    case translationId(String)
    /// Product name in translation for specific locale
    case translationName(String)
    /// Short product description in translation for specific locale
    case translationShortDescription(String)
    /// Product description in translation for specific locale
    case translationDescription(String)
    /// Is product translation active for specific locale
    case translationActive(String)
    /// Is product added during the install for specific locale
    case translationIsDefault(String)
    /// Language identifier for specific locale
    case translationLangId(String)
    /// SEO title displayed in <title> tag for specific locale
    case translationSeoTitle(String)
    /// SEO description displayed in meta description tag for specific locale
    case translationSeoDescription(String)
    /// SEO keywords displayed in meta keywords tag for specific locale
    case translationSeoKeywords(String)
    /// SEO URL slug displayed in URL for specific locale
    case translationSeoUrl(String)
    /// Full, direct URL to the product for specific locale
    case translationPermalink(String)
    /// Priority used to calculate upon product list sorting for specific locale
    case translationOrder(String)
    /// Is product unit price calculation enabled?
    case unitPriceCalculation
    /// Object creation datetime in ISO_8601 format
    case createdAt
    /// Latest object modification datetime in ISO_8601 format
    case updatedAt
    
    /// Returns the string value for the sort key
    public var rawValue: String {
        switch self {
        case .productId: return "product_id"
        case .type: return "type"
        case .producerId: return "producer_id"
        case .groupId: return "group_id"
        case .taxId: return "tax_id"
        case .unitId: return "unit_id"
        case .addDate: return "add_date"
        case .editDate: return "edit_date"
        case .otherPrice: return "other_price"
        case .dimensionW: return "dimension_w"
        case .dimensionH: return "dimension_h"
        case .dimensionL: return "dimension_l"
        case .pkwiu: return "pkwiu"
        case .loyaltyScore: return "loyalty_score"
        case .loyaltyPrice: return "loyalty_price"
        case .inLoyalty: return "in_loyalty"
        case .bestseller: return "bestseller"
        case .newproduct: return "newproduct"
        case .volWeight: return "vol_weight"
        case .gaugeId: return "gauge_id"
        case .currencyId: return "currency_id"
        case .stock: return "stock.stock"
        case .stockAvailabilityId: return "stock.availability_id"
        case .stockCalculatedAvailabilityId: return "stock.calculated_availability_id"
        case .stockDeliveryId: return "stock.delivery_id"
        case .stockPrice: return "stock.price"
        case .stockActive: return "stock.active"
        case .stockDefault: return "stock.default"
        case .stockSold: return "stock.sold"
        case .stockCode: return "stock.code"
        case .stockEan: return "stock.ean"
        case .stockWeight: return "stock.weight"
        case .stockWeightType: return "stock.weight_type"
        case .stockPriceWholesale: return "stock.price_wholesale"
        case .stockPriceSpecial: return "stock.price_special"
        case .translations: return "translations"
        case .translationId(let locale): return "translations.\(locale).translation_id"
        case .translationName(let locale): return "translations.\(locale).name"
        case .translationShortDescription(let locale): return "translations.\(locale).short_description"
        case .translationDescription(let locale): return "translations.\(locale).description"
        case .translationActive(let locale): return "translations.\(locale).active"
        case .translationIsDefault(let locale): return "translations.\(locale).isdefault"
        case .translationLangId(let locale): return "translations.\(locale).lang_id"
        case .translationSeoTitle(let locale): return "translations.\(locale).seo_title"
        case .translationSeoDescription(let locale): return "translations.\(locale).seo_description"
        case .translationSeoKeywords(let locale): return "translations.\(locale).seo_keywords"
        case .translationSeoUrl(let locale): return "translations.\(locale).seo_url"
        case .translationPermalink(let locale): return "translations.\(locale).permalink"
        case .translationOrder(let locale): return "translations.\(locale).order"
        case .unitPriceCalculation: return "unit_price_calculation"
        case .createdAt: return "created_at"
        case .updatedAt: return "updated_at"
        }
    }
}
    
extension Order where Key == ProductSortKey {
    public static func name(language: String = "pl_PL", direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.translationName(language), direction)
    }
    
    public static func stock(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.stock, direction)
    }
    
    public static func sold(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.stockSold, direction)
    }
    
    public static func price(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.stockPrice, direction)
    }
    
}
