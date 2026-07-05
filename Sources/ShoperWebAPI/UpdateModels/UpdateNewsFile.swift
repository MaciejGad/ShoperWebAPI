import Foundation

public struct UpdateNewsFile: Encodable, Sendable {
    public var name: String?
    /// Base64-encoded file contents.
    public var content: String?
    public var description: String?
    public var newsId: Int?
    public var order: Int?

    public init(
        name: String? = nil,
        content: String? = nil,
        description: String? = nil,
        newsId: Int? = nil,
        order: Int? = nil
    ) {
        self.name = name
        self.content = content
        self.description = description
        self.newsId = newsId
        self.order = order
    }
}
