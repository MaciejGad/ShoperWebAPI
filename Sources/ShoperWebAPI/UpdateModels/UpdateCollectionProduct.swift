import Foundation

public struct UpdateCollectionProduct: Encodable, Sendable {
    public var position: Int?

    public init(position: Int? = nil) {
        self.position = position
    }
}
