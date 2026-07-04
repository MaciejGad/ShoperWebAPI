import Foundation

/// Same paginated shape as `ResourceList`, but for nested/parent-scoped resources (e.g.
/// `CollectionProduct`, `PaymentChannel`) that don't conform to `Resource` since their endpoint
/// requires a `parentId` and therefore can't rely on `Resource`'s standard list/get/create/
/// update/delete methods.
public struct NestedResourceList<Model: Decodable & Sendable>: Decodable, Sendable {
    public let count: Int
    public let pages: Int
    public let page: Int
    public let list: [Model]

    enum CodingKeys: CodingKey {
        case count
        case pages
        case page
        case list
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decodeInt(forKey: .count)
        self.pages = try container.decode(Int.self, forKey: .pages)
        self.page = try container.decode(Int.self, forKey: .page)
        self.list = try container.decode([Model].self, forKey: .list)
    }
}
