import Foundation

public struct NewsTag: Decodable, Sendable {
    public let tagId: Int
    public let name: String?
    public let langId: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tagId = try container.decodeInt(forKey: .tagId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
    }

    enum CodingKeys: CodingKey {
        case tagId
        case name
        case langId
    }
}

extension NewsTag: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateNewsTag
    public typealias UpdatePayload = UpdateNewsTag

    public var id: Identifier { .id(tagId) }
    public static var endpoint: Endpoint { .newsTags }
}
