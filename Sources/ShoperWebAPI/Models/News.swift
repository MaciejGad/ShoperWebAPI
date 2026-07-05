import Foundation

/// A shop blog post.
public struct News: Decodable, Sendable {
    public let newsId: Int
    public let name: String?
    public let content: String?
    public let shortContent: String?
    public let date: String?
    public let langId: Int?
    public let author: String?
    public let active: Bool?
    public let box: Bool?
    public let startPage: Bool?
    public let order: Int?
    public let imageName: String?
    public let seoDescription: String?
    public let seoKeywords: String?
    public let seoTitle: String?
    public let seoUrl: String?
    /// Note: the OpenAPI spec documents this as an array of `NewsTag` objects, but the live API
    /// returns a flat array of tag ids (e.g. `"tags":[1,2,3]`) — confirmed live, 2026-07-04,
    /// sklep173975.shoparena.pl. Modeled as `[Int]` to match reality; look up `NewsTag.get` per
    /// id if you need the name.
    public let tags: [Int]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.newsId = try container.decodeInt(forKey: .newsId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.shortContent = try container.decodeIfPresent(String.self, forKey: .shortContent)
        self.date = try container.decodeDateStringIfPresent(forKey: .date)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.box = try container.decodeBoolIfPresent(forKey: .box)
        self.startPage = try container.decodeBoolIfPresent(forKey: .startPage)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        self.seoDescription = try container.decodeIfPresent(String.self, forKey: .seoDescription)
        self.seoKeywords = try container.decodeIfPresent(String.self, forKey: .seoKeywords)
        self.seoTitle = try container.decodeIfPresent(String.self, forKey: .seoTitle)
        self.seoUrl = try container.decodeIfPresent(String.self, forKey: .seoUrl)
        self.tags = (try? container.decodeIntArray(forKey: .tags)) ?? []
    }

    enum CodingKeys: CodingKey {
        case newsId
        case name
        case content
        case shortContent
        case date
        case langId
        case author
        case active
        case box
        case startPage
        case order
        case imageName
        case seoDescription
        case seoKeywords
        case seoTitle
        case seoUrl
        case tags
    }
}

extension News: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateNews
    public typealias UpdatePayload = UpdateNews

    public var id: Identifier { .id(newsId) }
    public static var endpoint: Endpoint { .news }
}
