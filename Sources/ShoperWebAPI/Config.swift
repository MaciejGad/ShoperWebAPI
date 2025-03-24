import Foundation

public struct Config {
    public let shopURL: URL
    public let login: String
    public let password: String
    public let verbose: Bool
    
    public init(shopURL: URL,
                login: String,
                password: String,
                verbose: Bool = false) {
        self.shopURL = shopURL
        self.login = login
        self.password = password
        self.verbose = verbose
    }
}
