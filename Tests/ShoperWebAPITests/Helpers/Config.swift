import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import ShoperWebAPI

func makeClient() throws -> Client {
    guard let mockEnvPath = Bundle.module.url(forResource: "mock_env", withExtension: "json") else {
        throw ConfigError.missingConfig
    }
    let data = try Data(contentsOf: mockEnvPath)
    let environment = try JSONDecoder().decode(Environment.self, from: data)
    let shopURL: URL
    let session: URLSession
    if let shopdomain = ProcessInfo.processInfo.environment["SHOPER_DOMAIN"], let rawShopURL = URL(string: "https://\(shopdomain)/") {
        shopURL = rawShopURL
        session = URLSession.shared
    } else {
        shopURL = environment.shopURL
        session = environment.session
    }
    let username = ProcessInfo.processInfo.environment["SHOPER_USERNAME"] ?? environment.username
    let password = ProcessInfo.processInfo.environment["SHOPER_PASSWORD"] ?? environment.password
    let config = Config(shopURL: shopURL, login: username, password: password, verbose: true, storeToFile: true)
    return Client(config: config, session: session)
}


enum ConfigError: Error {
    case missingConfig
}
