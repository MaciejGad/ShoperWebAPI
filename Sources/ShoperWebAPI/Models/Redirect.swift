import Foundation

public struct Redirect: Decodable, Sendable {
    public let redirectId: Int
    public let langId: Int?
    public let objectId: Int?
    public let route: String?
    public let target: String?
    public let type: RedirectType?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.redirectId = try container.decodeInt(forKey: .redirectId)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.objectId = try container.decodeIntIfPresent(forKey: .objectId)
        self.route = try container.decodeIfPresent(String.self, forKey: .route)
        self.target = try container.decodeIfPresent(String.self, forKey: .target)
        self.type = try container.decodeIfPresent(RedirectType.self, forKey: .type)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case redirectId
        case langId
        case objectId
        case route
        case target
        case type
    }
}

extension Redirect: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = RedirectPayload
    public typealias UpdatePayload = RedirectPayload

    public var id: Identifier { .id(redirectId) }
    public static var endpoint: Endpoint { .redirects }
}
