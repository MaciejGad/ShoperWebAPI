import Foundation

public struct Config {
    public let shopURL: URL
    public let login: String
    public let password: String
    public let accessToken: String?
    public let defaultLanguage: String
    public let verbose: Bool
    let storeToFile: Bool

    public init(shopURL: URL,
                login: String = "",
                password: String = "",
                accessToken: String? = nil,
                defaultLanguage: String = "pl_PL",
                verbose: Bool = false,
                storeToFile: Bool = false) {
        self.shopURL = shopURL
        self.login = login
        self.password = password
        self.accessToken = accessToken
        self.defaultLanguage = defaultLanguage
        self.verbose = verbose
        self.storeToFile = storeToFile
    }
}
