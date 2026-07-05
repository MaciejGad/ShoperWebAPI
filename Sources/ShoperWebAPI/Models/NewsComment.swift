import Foundation

public struct NewsComment: Decodable, Sendable {
    public let commId: Int
    public let content: String?
    public let date: String?
    public let langId: Int?
    public let newsId: Int?
    public let userId: Int?
    public let userName: String?
    public let validated: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commId = try container.decodeInt(forKey: .commId)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.date = try container.decodeDateStringIfPresent(forKey: .date)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.newsId = try container.decodeIntIfPresent(forKey: .newsId)
        self.userId = try container.decodeIntIfPresent(forKey: .userId)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.validated = try container.decodeBoolIfPresent(forKey: .validated)
    }

    enum CodingKeys: CodingKey {
        case commId
        case content
        case date
        case langId
        case newsId
        case userId
        case userName
        case validated
    }
}

extension NewsComment: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateNewsComment
    public typealias UpdatePayload = UpdateNewsComment

    public var id: Identifier { .id(commId) }
    public static var endpoint: Endpoint { .newsComments }
}
