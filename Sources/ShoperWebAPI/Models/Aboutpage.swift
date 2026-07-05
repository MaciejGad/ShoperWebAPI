import Foundation

/// A shop static page (e.g. "About us", "Terms of service").
public struct Aboutpage: Decodable, Sendable {
    public let pageId: Int
    public let name: String?
    public let langId: Int?
    public let content: String?
    public let active: Bool?
    public let seoDescription: String?
    public let seoKeywords: String?
    public let seoTitle: String?
    public let seoUrl: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pageId = try container.decodeInt(forKey: .pageId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.seoDescription = try container.decodeIfPresent(String.self, forKey: .seoDescription)
        self.seoKeywords = try container.decodeIfPresent(String.self, forKey: .seoKeywords)
        self.seoTitle = try container.decodeIfPresent(String.self, forKey: .seoTitle)
        self.seoUrl = try container.decodeIfPresent(String.self, forKey: .seoUrl)
    }

    enum CodingKeys: CodingKey {
        case pageId
        case name
        case langId
        case content
        case active
        case seoDescription
        case seoKeywords
        case seoTitle
        case seoUrl
    }
}

extension Aboutpage: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateAboutpage
    public typealias UpdatePayload = UpdateAboutpage

    public var id: Identifier { .id(pageId) }
    public static var endpoint: Endpoint { .aboutpages }
}
