import Foundation

/// A product's membership/position within a `Collection`. Nested under
/// `/collections/{collection_id}/products` — doesn't conform to `Resource` since the endpoint
/// requires a `collectionId` alongside the usual `id`. There's no create/delete endpoint for
/// this relationship (products are presumably added/removed elsewhere); only listing and
/// updating `position` are supported.
public struct CollectionProduct: Decodable, Sendable {
    public let productId: Int
    /// Only meaningful (and only settable) when the parent `Collection.sortType` is manual
    /// sorting; `nil` otherwise.
    public let position: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decodeInt(forKey: .productId)
        self.position = try container.decodeIntIfPresent(forKey: .position)
    }

    enum CodingKeys: CodingKey {
        case productId
        case position
    }

    public static func list(client: ClientProtocol, collectionId: Int, page: Int? = nil, limit: Int? = nil) async throws -> NestedResourceList<CollectionProduct> {
        let data = try await client.get(endpoint: .collectionProducts, parentId: collectionId, id: nil, filters: nil, sort: nil, page: page, limit: limit)
        return try client.decode(data: data)
    }

    /// Updates the product's `position` within the collection. The live API documents the
    /// response as either a raw `0`/`1` or the updated `CollectionProduct`; only the write is
    /// exposed here since callers already know what they set.
    public static func update(client: ClientProtocol, collectionId: Int, productId: Int, payload: UpdateCollectionProduct) async throws {
        _ = try await client.put(endpoint: .collectionProducts, parentId: collectionId, id: productId, payload: payload)
    }
}
