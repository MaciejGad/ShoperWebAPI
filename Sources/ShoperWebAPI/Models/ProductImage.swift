import Foundation

public struct ProductImage: Codable {
    public let gfxId: Int?
    public let productId: Int?
    public let main: Bool
    public let order: Int
    public let name: String
    public let unicName: String
    public let hidden: Bool
    public let `extension`: String
    public let translations: [String: Translation]?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gfxId = try container.decodeInt(forKey: .gfxId)
        self.productId = try container.decodeIntIfPresent(forKey: .productId)
        self.main = try container.decodeBoolIfPresent(forKey: .main) ?? true
        self.order = try container.decodeInt(forKey: .order)
        self.name = try container.decode(String.self, forKey: .name)
        self.unicName = try container.decode(String.self, forKey: .unicName)
        self.hidden = try container.decodeBool(forKey: .hidden)
        self.extension = try container.decode(String.self, forKey: .extension)
        self.translations = try container.decodeIfPresent([String: Translation].self, forKey: .translations)
    }
    
    public struct Translation: Codable {
        public let translationId: Int
        public let gfxId: Int
        public let name: String
        public let langId: Int
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.translationId = try container.decodeInt(forKey: .translationId)
            self.gfxId = try container.decodeInt(forKey: .gfxId)
            self.name = try container.decode(String.self, forKey: .name)
            self.langId = try container.decodeInt(forKey: .langId)
        }
    }
}

extension ProductImage: Resource {
    public typealias Key = ProductImageFilterKey
    public typealias CreatePayload = CreateProductImage
    public typealias UpdatePayload = UpdateProductImage
    
    var id: Identifier {
        return gfxId.map { Identifier.id($0) } ?? .none
    }
    
    static var endpoint: Endpoint {
        .images
    }
}
