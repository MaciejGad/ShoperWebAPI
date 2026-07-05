import Foundation

public struct UpdateAboutpage: Encodable, Sendable {
    public var name: String?
    public var langId: Int?
    public var active: Bool?
    public var content: String?
    public var seoDescription: String?
    public var seoKeywords: String?
    public var seoTitle: String?
    public var seoUrl: String?

    public init(
        name: String? = nil,
        langId: Int? = nil,
        active: Bool? = nil,
        content: String? = nil,
        seoDescription: String? = nil,
        seoKeywords: String? = nil,
        seoTitle: String? = nil,
        seoUrl: String? = nil
    ) {
        self.name = name
        self.langId = langId
        self.active = active
        self.content = content
        self.seoDescription = seoDescription
        self.seoKeywords = seoKeywords
        self.seoTitle = seoTitle
        self.seoUrl = seoUrl
    }
}
