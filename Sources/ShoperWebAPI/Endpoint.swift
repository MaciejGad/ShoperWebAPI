import Foundation

public enum Endpoint: String {
    case auth = "webapi/rest/auth"
    case products = "webapi/rest/products"
    case images = "webapi/rest/product-images"
    case orderProducts = "webapi/rest/order-products"
    case orders = "webapi/rest/orders"
    case attributes = "webapi/rest/attributes"
    case categories = "webapi/rest/categories"
    case categoriesTree = "webapi/rest/categories-tree"
    case productStocks = "webapi/rest/product-stocks"
    case attributeGroups = "webapi/rest/attribute-groups"
    case producers = "webapi/rest/producers"
    case taxes = "webapi/rest/taxes"
    case units = "webapi/rest/units"
    case deliveries = "webapi/rest/deliveries"
    case availabilities = "webapi/rest/availabilities"
    case gauges = "webapi/rest/gauges"
    case currencies = "webapi/rest/currencies"
    case productSafetyProducers = "webapi/rest/product-safety-producers"
    case productSafetyImporters = "webapi/rest/product-safety-importers"
    case productSafetyResponsibles = "webapi/rest/product-safety-responsibles"
    case productSafetyCertificates = "webapi/rest/product-safety-certificates"
    case productTags = "webapi/rest/product-tags"
    case collections = "webapi/rest/collections"
    case optionGroups = "webapi/rest/option-groups"
    case options = "webapi/rest/options"
    case optionValues = "webapi/rest/option-values"
    case productFiles = "webapi/rest/product-files"
    case statuses = "webapi/rest/statuses"
    case orderTags = "webapi/rest/order-tags"
    case shippings = "webapi/rest/shippings"
    case payments = "webapi/rest/payments"
    case zones = "webapi/rest/zones"
    case promotionCodes = "webapi/rest/promotion-codes"
    case specialOffers = "webapi/rest/specialoffers"
    case parcels = "webapi/rest/parcels"
    case orderRefunds = "webapi/rest/order-refunds"
    case orderTransactions = "webapi/rest/order-transactions"
    case redirects = "webapi/rest/redirects"
    case users = "webapi/rest/users"
    case userAddresses = "webapi/rest/user-addresses"
    case userGroups = "webapi/rest/user-groups"
    case userTags = "webapi/rest/user-tags"
    case subscribers = "webapi/rest/subscribers"
    case subscriberGroups = "webapi/rest/subscriber-groups"
    case geolocationCountries = "webapi/rest/geolocation-countries"
    case geolocationRegions = "webapi/rest/geolocation-regions"
    case geolocationSubregions = "webapi/rest/geolocation-subregions"
    case languages = "webapi/rest/languages"
    case applicationConfig = "webapi/rest/application-config"
    case applicationLock = "webapi/rest/application-lock"
    case applicationVersion = "webapi/rest/application-version"
    case progresses = "webapi/rest/progresses"
    case additionalFields = "webapi/rest/additional-fields"
    case additionalFieldOptions = "webapi/rest/additional-field-options"
    case metafieldValues = "webapi/rest/metafield-values"
    case metafieldBind = "webapi/rest/metafield-bind"
    case webhooks = "webapi/rest/webhooks"
    case loyaltyEvents = "webapi/rest/loyalty-events"
    case dashboardActivities = "webapi/rest/dashboard-activities"
    case dashboardStats = "webapi/rest/dashboard-stats"
    case aboutpages = "webapi/rest/aboutpages"
    case news = "webapi/rest/news"
    case newsCategories = "webapi/rest/news-categories"
    case newsComments = "webapi/rest/news-comments"
    case newsFiles = "webapi/rest/news-files"
    case newsTags = "webapi/rest/news-tags"
    /// Nested under a collection: rawValue embeds a `:collection_id` placeholder that
    /// `url(config:parentId:...)` substitutes with the actual collection id before use.
    case collectionProducts = "webapi/rest/collections/:collection_id/products"
    /// Nested under a payment: rawValue embeds a `:payment_id` placeholder that
    /// `url(config:parentId:...)` substitutes with the actual payment id before use.
    case paymentChannels = "webapi/rest/payments/:payment_id/channels"

    /// - Parameter parentId: substituted for the `:placeholder` token embedded in `rawValue` for
    ///   nested endpoints (e.g. `collectionProducts`, `paymentChannels`). Required if `rawValue`
    ///   contains a placeholder, ignored otherwise.
    func url(config: Config, parentId: Int? = nil, id: Int?  = nil, filters: String? = nil, sort: SortOrder? = nil, page: Int? = nil, limit: Int? = nil) throws -> URL {
        var path = rawValue
        if let colonIndex = path.firstIndex(of: ":") {
            guard let parentId else {
                throw ShoperError.invalidURL
            }
            let placeholderEnd = path[colonIndex...].firstIndex(of: "/") ?? path.endIndex
            path.replaceSubrange(colonIndex..<placeholderEnd, with: String(parentId))
        }
        var url = config.shopURL.appendingPathComponent(path)
        if let id {
            url.appendPathComponent(String(id))
        }
        var queryItems: [URLQueryItem] = []
        if let filters, !filters.isEmpty {
            queryItems.append(.init(name: "filters", value: filters))
        }
        if let page {
            queryItems.append(.init(name: "page", value: String(page)))
        }
        if let sort, !sort.values.isEmpty {
            for order in sort.values {
                queryItems.append(.init(name: "order[]", value: order))
            }
        }
        if let limit {
            queryItems.append(.init(name: "limit", value: String(limit)))
        }
            
        guard !queryItems.isEmpty else {
            return url
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let newURL = urlComponents?.url else {
            throw ShoperError.invalidURL
        }
        return newURL
    }
}
