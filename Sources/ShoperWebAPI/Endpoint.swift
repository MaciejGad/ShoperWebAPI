import Foundation

enum Endpoint: String {
    case auth = "webapi/rest/auth"
    case products = "webapi/rest/products"
    
    func url(config: Config, id: Int?  = nil, filters: String? = nil) throws -> URL {
        var url = config.shopURL.appendingPathComponent(rawValue)
        if let id {
            url.appendPathComponent(String(id))
        }
        if let filters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = [URLQueryItem(name: "filters", value: filters)]
            guard let newURL = urlComponents?.url else {
                throw ShoperError.invalidURL
            }
            return newURL
        }
        return url
    }
}
