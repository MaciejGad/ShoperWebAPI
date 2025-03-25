import Foundation

public struct Config {
    public let shopURL: URL
    public let login: String
    public let password: String
    public let defaultLanguage: String
    public let verbose: Bool
    
    public init(shopURL: URL,
                login: String,
                password: String,
                defaultLanguage: String = "pl_PL",
                verbose: Bool = false) {
        self.shopURL = shopURL
        self.login = login
        self.password = password
        self.defaultLanguage = defaultLanguage
        self.verbose = verbose
    }
}
