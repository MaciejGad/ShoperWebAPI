import Foundation

public struct UpdateProduct: Codable {
    /// stock update
    public let stock: UpdateStock?
    
    /// translations
    public let translations: [String: UpdateProductTranslation]?
    
    public init(stock: UpdateStock? = nil, translations: [String : UpdateProductTranslation]? = nil) {
        self.stock = stock
        self.translations = translations
    }
}
