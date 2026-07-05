import Foundation

/// Note: the OpenAPI spec's `required` list for `NewsFileInsert` is just `[name]`, but the live
/// API disagrees (confirmed 2026-07-04, sklep173975.shoparena.pl): omitting `newsId` defaults it
/// to `0`, which is rejected with "News does not exist". Modeled as non-optional here to match
/// reality.
public struct CreateNewsFile: Encodable, Sendable {
    public var name: String
    public var newsId: Int
    /// Base64-encoded file contents.
    public var content: String?
    public var description: String?
    public var order: Int?

    public init(
        name: String,
        newsId: Int,
        content: String? = nil,
        description: String? = nil,
        order: Int? = nil
    ) {
        self.name = name
        self.newsId = newsId
        self.content = content
        self.description = description
        self.order = order
    }

    /// Convenience initializer that base64-encodes raw file data.
    public static func file(
        content: Data,
        name: String,
        newsId: Int,
        description: String? = nil,
        order: Int? = nil
    ) -> CreateNewsFile {
        .init(name: name, newsId: newsId, content: content.base64EncodedString(), description: description, order: order)
    }
}
