import Foundation

public struct UpdateMetafieldValue: Encodable, Sendable {
    public var metafieldId: Int?
    public var objectId: Int?
    public var value: String?

    public init(metafieldId: Int? = nil, objectId: Int? = nil, value: String? = nil) {
        self.metafieldId = metafieldId
        self.objectId = objectId
        self.value = value
    }
}
