import Foundation

public struct CreateAuctionHouse: Encodable, Sendable {
    public var name: String
    public var active: Bool?
    public var order: Int?

    public init(name: String, active: Bool? = nil, order: Int? = nil) {
        self.name = name
        self.active = active
        self.order = order
    }
}
