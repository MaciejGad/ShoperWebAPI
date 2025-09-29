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
    let config = Config(shopURL: environment.shopURL, login: environment.username, password: environment.password, verbose: true, storeToFile: true)
    return Client(config: config, session: environment.session)
}


enum ConfigError: Error {
    case missingConfig
}
