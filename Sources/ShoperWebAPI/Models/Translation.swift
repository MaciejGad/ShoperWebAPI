import Foundation

struct Translation: Codable {
    let translationId: Int
    let productId: Int
    let name: String
    let shortDescription: String
    let description: String
    let active: Bool
    let isdefault: Bool
    let langId: Int
    let seoTitle: String
    let seoDescription: String
    let seoKeywords: String
    let seoUrl: String?
    let permalink: String
    let order: Int
    let mainPage: Bool
    let mainPageOrder: Int
    
    init(from decoder: any Decoder) throws {
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
