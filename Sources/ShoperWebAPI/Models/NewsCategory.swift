import Foundation

public struct NewsCategory: Decodable, Sendable {
    public let categoryId: Int
    public let name: String?
    public let langId: Int?
    public let active: Bool?
    public let order: Int?
    public let seoDescription: String?
    public let seoKeywords: String?
    public let seoTitle: String?
    public let seoUrl: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categoryId = try container.decodeInt(forKey: .categoryId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.seoDescription = try container.decodeIfPresent(String.self, forKey: .seoDescription)
        self.seoKeywords = try container.decodeIfPresent(String.self, forKey: .seoKeywords)
        self.seoTitle = try container.decodeIfPresent(String.self, forKey: .seoTitle)
        self.seoUrl = try container.decodeIfPresent(String.self, forKey: .seoUrl)
    }

    enum CodingKeys: CodingKey {
        case categoryId
        case name
        case langId
        case active
        case order
        case seoDescription
        case seoKeywords
        case seoTitle
        case seoUrl
    }
}

extension NewsCategory: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateNewsCategory
    public typealias UpdatePayload = UpdateNewsCategory

    public var id: Identifier { .id(categoryId) }
    public static var endpoint: Endpoint { .newsCategories }
}
