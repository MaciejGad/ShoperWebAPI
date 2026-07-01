import Foundation

extension Attributes {
    /// `GET /products/{id}` returns attributes nested as `attribute_group_id -> attribute_id -> value`.
    /// `ProductInsert.attributes` expects a flat map of `attribute_id -> value`.
    public func flattenedForProductInsert() -> [String: String] {
        var flattened: [String: String] = [:]
        for group in values.values {
            for (attributeId, value) in group.values {
                flattened[attributeId] = value
            }
        }
        return flattened
    }
}
