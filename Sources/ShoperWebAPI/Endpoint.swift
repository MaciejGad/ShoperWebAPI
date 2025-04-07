import Foundation

public enum Endpoint: String {
    case auth = "webapi/rest/auth"
    case products = "webapi/rest/products"
    case images = "webapi/rest/product-images"
    
    func url(config: Config, id: Int?  = nil, filters: String? = nil, page: Int? = nil) throws -> URL {
        var url = config.shopURL.appendingPathComponent(rawValue)
        if let id {
            url.appendPathComponent(String(id))
        }
        var queryItems: [URLQueryItem] = []
        if let filters {
            queryItems.append(.init(name: "filters", value: filters))
        }
        if let page {
            queryItems.append(.init(name: "page", value: String(page)))
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
