import Foundation

enum Endpoint: String {
    case auth = "webapi/rest/auth"
    
    func url(config: Config) -> URL {
        config.shopURL.appendingPathComponent(rawValue)
    }
}
