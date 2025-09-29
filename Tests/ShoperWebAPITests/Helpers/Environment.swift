import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct Environment: Decodable {
    let password: String
    let username: String
    let shopURL: URL
    let session: URLSession
    
    enum CodingKeys: String, CodingKey {
        case password
        case username
        case shopURL
        case session
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.password = try container.decode(String.self, forKey: CodingKeys.password)
        self.username = try container.decode(String.self, forKey: CodingKeys.username)
        self.shopURL = try container.decode(URL.self, forKey: CodingKeys.shopURL)
        let session = try container.decode(String.self, forKey: CodingKeys.session)
        switch session {
        case "mock":
            self.session = mockUrlSession()
        default:
            self.session = URLSession.shared
        }
    }
    
    init(password: String, username: String, shopURL: URL, session: URLSession) {
        self.password = password
        self.username = username
        self.shopURL = shopURL
        self.session = session
    }
}
