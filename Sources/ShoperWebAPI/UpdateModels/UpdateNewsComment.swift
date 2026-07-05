import Foundation

public struct UpdateNewsComment: Encodable, Sendable {
    public var newsId: Int?
    public var content: String?
    public var date: String?
    public var langId: Int?
    public var userId: Int?
    public var userName: String?
    public var validated: Bool?

    public init(
        newsId: Int? = nil,
        content: String? = nil,
        date: String? = nil,
        langId: Int? = nil,
        userId: Int? = nil,
        userName: String? = nil,
        validated: Bool? = nil
    ) {
        self.newsId = newsId
        self.content = content
        self.date = date
        self.langId = langId
        self.userId = userId
        self.userName = userName
        self.validated = validated
    }
}
