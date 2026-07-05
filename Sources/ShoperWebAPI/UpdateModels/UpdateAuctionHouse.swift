import Foundation

public struct UpdateAuctionHouse: Encodable, Sendable {
    public var name: String?
    public var active: Bool?
    public var order: Int?

    public init(name: String? = nil, active: Bool? = nil, order: Int? = nil) {
        self.name = name
        self.active = active
        self.order = order
    }
}
