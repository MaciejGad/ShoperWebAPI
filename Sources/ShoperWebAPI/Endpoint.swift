import Foundation

enum Endpoint: String {
    case auth = "webapi/rest/auth"
    case products = "webapi/rest/products"
    
    func url(config: Config, id: Int?  = nil) -> URL {
        var url = config.shopURL.appendingPathComponent(rawValue)
        if let id {
            url.appendPathComponent(String(id))
        }
        return url
    }
}
