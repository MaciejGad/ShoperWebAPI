import Foundation

public struct CreateNews: Encodable, Sendable {
    public var name: String
    public var content: String
    /// Format `YYYY-MM-DD HH:mm:ss`.
    public var date: String
    public var langId: Int
    public var active: Bool?
    public var author: String?
    public var box: Bool?
    /// Comma-separated category ids (the API documents this as a plain string, not a JSON array).
    public var categories: String?
    /// Base64-encoded cover image content.
    public var image: String?
    public var imageName: String?
    public var order: Int?
    public var seoDescription: String?
    public var seoKeywords: String?
    public var seoTitle: String?
    public var seoUrl: String?
    public var shortContent: String?
    public var startPage: Bool?

    public init(
        name: String,
        content: String,
        date: String,
        langId: Int,
        active: Bool? = nil,
        author: String? = nil,
        box: Bool? = nil,
        categories: String? = nil,
        image: String? = nil,
        imageName: String? = nil,
        order: Int? = nil,
        seoDescription: String? = nil,
        seoKeywords: String? = nil,
        seoTitle: String? = nil,
        seoUrl: String? = nil,
        shortContent: String? = nil,
        startPage: Bool? = nil
    ) {
        self.name = name
        self.content = content
        self.date = date
        self.langId = langId
        self.active = active
        self.author = author
        self.box = box
        self.categories = categories
        self.image = image
        self.imageName = imageName
        self.order = order
        self.seoDescription = seoDescription
        self.seoKeywords = seoKeywords
        self.seoTitle = seoTitle
        self.seoUrl = seoUrl
        self.shortContent = shortContent
        self.startPage = startPage
    }
}
