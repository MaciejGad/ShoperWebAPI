import Foundation

/// Note: the OpenAPI spec lists no `required` fields at all for `NewsCommentInsert`, but the live
/// API disagrees (confirmed 2026-07-04, sklep173975.shoparena.pl): omitting `langId` defaults it
/// to `0`, which is rejected ("Nie znaleziono wartości '0'" — value not found, since language id
/// 0 doesn't exist), and omitting `userName` fails validation ("Pole wymagane" — field required).
/// `newsId`/`content` are modeled as non-optional for the same reason a comment without either
/// doesn't make sense. Pass a real `langId` (see `Language.list`) and a `userName`.
public struct CreateNewsComment: Encodable, Sendable {
    public var newsId: Int
    public var content: String
    public var langId: Int
    public var userName: String
    public var date: String?
    public var userId: Int?
    public var validated: Bool?

    public init(
        newsId: Int,
        content: String,
        langId: Int,
        userName: String,
        date: String? = nil,
        userId: Int? = nil,
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
