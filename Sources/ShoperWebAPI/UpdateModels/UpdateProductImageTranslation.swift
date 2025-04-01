import Foundation

public struct UpdateProductImageTranslation: Codable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
