import Foundation

public struct AuctionHouse: Decodable, Sendable {
    public let auctionHouseId: Int
    public let name: String?
    public let active: Bool?
    public let order: Int?
    /// Auction system engine name (e.g. the marketplace integration this house represents).
    public let engine: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.auctionHouseId = try container.decodeInt(forKey: .auctionHouseId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.engine = try container.decodeIfPresent(String.self, forKey: .engine)
    }

    enum CodingKeys: CodingKey {
        case auctionHouseId
        case name
        case active
        case order
        case engine
    }
}

extension AuctionHouse: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateAuctionHouse
    public typealias UpdatePayload = UpdateAuctionHouse

    public var id: Identifier { .id(auctionHouseId) }
    public static var endpoint: Endpoint { .auctionHouses }
}
