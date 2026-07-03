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
    
    func url(config: Config, id: Int?  = nil, filters: String? = nil, sort: SortOrder? = nil, page: Int? = nil, limit: Int? = nil) throws -> URL {
        var url = config.shopURL.appendingPathComponent(rawValue)
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
