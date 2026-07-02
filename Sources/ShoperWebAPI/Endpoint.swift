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
