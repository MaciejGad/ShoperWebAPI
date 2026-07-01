import Foundation

public struct CreateProductTranslation: Encodable, Sendable {
    public var name: String?
    public var shortDescription: String?
    public var description: String?
    public var active: Bool?
    public var seoTitle: String?
    public var seoDescription: String?
    public var seoKeywords: String?
    public var seoUrl: String?
    public var order: Int?

    public init(
        name: String? = nil,
        shortDescription: String? = nil,
        description: String? = nil,
        active: Bool? = nil,
        seoTitle: String? = nil,
        seoDescription: String? = nil,
        seoKeywords: String? = nil,
        seoUrl: String? = nil,
        order: Int? = nil
    ) {
        self.name = name
        self.shortDescription = shortDescription
        self.description = description
        self.active = active
        self.seoTitle = seoTitle
        self.seoDescription = seoDescription
        self.seoKeywords = seoKeywords
        self.seoUrl = seoUrl
        self.order = order
    }

    /// Copies only the fields writable by ProductInsert/ProductUpdate.
    /// Skips read-only fields: translationId, productId, isdefault, langId, permalink.
    /// Skips deprecated fields: mainPage, mainPageOrder.
    public init(copying translation: Translation) {
        self.name = translation.name
        self.shortDescription = translation.shortDescription
        self.description = translation.description
        self.active = translation.active
        self.seoTitle = translation.seoTitle
        self.seoDescription = translation.seoDescription
        self.seoKeywords = translation.seoKeywords
        self.seoUrl = translation.seoUrl
        self.order = translation.order
    }
}
