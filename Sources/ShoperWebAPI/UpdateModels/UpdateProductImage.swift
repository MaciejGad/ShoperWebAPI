import Foundation

public struct UpdateProductImage: Codable {
    /// product identifier
    public let productId: Int?
    
    /// if present, file contents is being downloaded from specified URL
    public let url: String?
    
    /// base64-encoded file contents
    public let content: String?
    
    /// is the photo hidden
    public let hidden: Bool?
    
    /// an associative array with object translations; if you want to filter things - you can skip locale subkey
    public let translations: [String: UpdateProductImageTranslation]?
    
    public init(productId: Int? = nil, url: String? = nil, content: String? = nil, hidden: Bool? = nil, translations: [String : UpdateProductImageTranslation]? = nil) {
        self.productId = productId
        self.url = url
        self.content = content
        self.hidden = hidden
        self.translations = translations
    }
}
