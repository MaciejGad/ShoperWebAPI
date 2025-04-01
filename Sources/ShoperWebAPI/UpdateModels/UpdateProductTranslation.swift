import Foundation

public struct UpdateProductTranslation: Codable {
    /// product name
    public let name: String?
 
    /// short product description
    public let shortDescription: String?
    
    /// product description
    public let description: String?
    
    public init(name: String? = nil, shortDescription: String? = nil, description: String? = nil) {
        self.name = name
        self.shortDescription = shortDescription
        self.description = description
    }
}
