import Foundation

/// `POST /metafield-bind` — associates a metafield value with a specific object instance
/// (e.g. a product, category, or order). Write-only: there's no list/get for bindings, and the
/// endpoint requires the `metafields_bind` feature flag to be enabled on the shop (expect
/// HTTP 403/404 if it isn't).
public struct MetafieldBind: Encodable, Sendable {
    /// Object type to bind the metafield to (e.g. "product", "category", "order").
    public var type: String
    /// Identifier of the object instance to bind the metafield to.
    ///
    /// Note: unlike most numeric ids elsewhere in this API's Insert payloads (typically
    /// `type: integer`), the OpenAPI schema for this specific field is `type: string, pattern:
    /// ^[0-9]+$` — the request body for this endpoint reuses the base `MetafieldBind` schema
    /// directly rather than a separate `*Insert` variant. Modeled as `String` to match that
    /// literally rather than guessing whether the live API also accepts a JSON integer.
    public var itemId: String
    public var metafieldId: Int
    public var value: String

    public init(type: String, itemId: String, metafieldId: Int, value: String) {
        self.type = type
        self.itemId = itemId
        self.metafieldId = metafieldId
        self.value = value
    }

    /// Creates the binding. Returns the identifier of the newly created binding.
    public static func create(client: ClientProtocol, payload: MetafieldBind) async throws -> Int {
        let data = try await client.post(endpoint: .metafieldBind, payload: payload)
        return try client.decode(data: data)
    }
}
