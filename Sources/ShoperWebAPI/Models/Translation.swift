import Foundation

public struct Translation: Codable {
    public let translationId: Int
    public let productId: Int
    public let name: String
    public let shortDescription: String
    public let description: String
    public let active: Bool
    public let isdefault: Bool
    public let langId: Int
    public let seoTitle: String
    public let seoDescription: String
    public let seoKeywords: String
    public let seoUrl: String?
    public let permalink: String
    public let order: Int
    public let mainPage: Bool
    public let mainPageOrder: Int
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.translationId = try container.decodeInt(forKey: .translationId)
        self.productId = try container.decodeInt(forKey: .productId)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.description = try container.decode(String.self, forKey: .description)
        self.active = try container.decodeBool(forKey: .active)
        self.isdefault = try container.decodeBool(forKey: .isdefault)
        self.langId = try container.decodeInt(forKey: .langId)
        self.seoTitle = try container.decode(String.self, forKey: .seoTitle)
        self.seoDescription = try container.decode(String.self, forKey: .seoDescription)
        self.seoKeywords = try container.decode(String.self, forKey: .seoKeywords)
        self.seoUrl = try container.decodeIfPresent(String.self, forKey: .seoUrl)
        self.permalink = try container.decode(String.self, forKey: .permalink)
        self.order = try container.decodeInt(forKey: .order)
        self.mainPage = try container.decodeBool(forKey: .mainPage)
        self.mainPageOrder = try container.decodeInt(forKey: .mainPageOrder)
    }
}
