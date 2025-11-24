import Foundation

public struct UpdateProduct: Codable {
    /// stock update
    public let stock: UpdateStock?
    
    /// code
    public let code: String?
    
    /// translations
    public let translations: [String: UpdateProductTranslation]?
    

    
    public init(
        stock: UpdateStock? = nil,
        code: String? = nil,
        translations: [String : UpdateProductTranslation]? = nil) {
            self.stock = stock
            self.code = code
            self.translations = translations
    }
}
