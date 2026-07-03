import Foundation

/// A value stored for a [metafield](https://developers.shoper.pl/developers/api) — the generic
/// key/value storage mechanism attaching arbitrary data to shop objects.
///
/// Note: the base `Metafield` resource (definitions, listed at `GET /metafields/{object}`) is
/// not modeled in this SDK — its URL requires a dynamic string path segment (the object type)
/// before an optional numeric id, which doesn't fit the `Endpoint`/`Resource` pattern used
/// elsewhere without changing `ClientProtocol`'s stable signature. `MetafieldValue` (this type)
/// covers the more commonly useful half of the feature: reading/writing values once you already
/// know a `metafieldId`.
public struct MetafieldValue: Decodable, Sendable {
    public let valueId: Int
    public let metafieldId: Int?
    public let objectId: Int?
    public let value: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.valueId = try container.decodeInt(forKey: .valueId)
        self.metafieldId = try container.decodeIntIfPresent(forKey: .metafieldId)
        self.objectId = try container.decodeIntIfPresent(forKey: .objectId)
        self.value = try container.decodeIfPresent(String.self, forKey: .value)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case valueId
        case metafieldId
        case objectId
        case value
    }
}

extension MetafieldValue: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateMetafieldValue
    public typealias UpdatePayload = UpdateMetafieldValue

    public var id: Identifier { .id(valueId) }
    public static var endpoint: Endpoint { .metafieldValues }
}
