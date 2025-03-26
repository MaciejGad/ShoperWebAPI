import Foundation

/// Represents a product photo with optional content and translations.
public struct CreateProductImage: Codable {
    /// The product identifier
    /// If present, indicates which product the photo belongs to
    var productId: Int?
    /// The URL from which the photo content can be downloaded
    /// If present, the app may fetch the file contents from this address
    var url: String?
    /// The base64-encoded content of the file
    /// Used when the photo is provided directly rather than via URL
    var content: String?
    /// Indicates whether the photo is hidden
    /// Can be used to filter out photos in the user interface
    var hidden: Bool?
    /// Translations of the photo description in different languages
    /// The key is a locale code (e.g., `"pl_PL"`), and the value is a `Translation` containing the localized name
    var translations: [String: Translation]
    
    /// Represents a localized name of the photo
    public struct Translation: Codable {
        /// The localized name of the photo
        public var name: String
        
        /// Initializes a new instance of the structure
        public init(name: String) {
            self.name = name
        }
    }
    
    /// Initializes a new instance of the structure
    public init(productId: Int? = nil, url: String? = nil, content: String? = nil, hidden: Bool? = nil, translations: [String : Translation]) {
        self.productId = productId
        self.url = url
        self.content = content
        self.hidden = hidden
        self.translations = translations
    }
    
    /// Initializes download photo from URL
    public static func image(url: String, productId: Int? = nil, name: String, language: String = "pl_PL") -> CreateProductImage {
        .init(productId: productId, url: url, hidden: false, translations: [language: .init(name: name)])
    }
    
    /// Initializes photo with base64 content
    public static func image(content: Data, productId: Int? = nil, name: String, language: String = "pl_PL") -> CreateProductImage {
        .init(productId: productId, content: content.base64EncodedString(), hidden: false, translations: [language: .init(name: name)])
    }
}
