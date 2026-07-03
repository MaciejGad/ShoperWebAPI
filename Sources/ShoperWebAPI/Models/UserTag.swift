import Foundation

public struct UserTag: Decodable, Sendable {
    public let tagId: Int
    public let name: String
    public let langId: Int

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tagId = try container.decodeInt(forKey: .tagId)
        self.name = try container.decode(String.self, forKey: .name)
        self.langId = try container.decodeInt(forKey: .langId)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case tagId
        case name
        case langId
    }
}

extension UserTag: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateUserTag
    public typealias UpdatePayload = UpdateUserTag

    public var id: Identifier { .id(tagId) }
    public static var endpoint: Endpoint { .userTags }
}
