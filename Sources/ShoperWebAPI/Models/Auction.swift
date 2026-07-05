import Foundation

/// A listing on a connected marketplace/auction house (e.g. Allegro).
public struct Auction: Decodable, Sendable {
    public let auctionId: Int
    public let auctionHouseId: Int?
    public let productId: Int?
    public let stockId: Int?
    public let realAuctionId: String?
    public let title: String?
    /// `0` - bidding, `1` - immediate (buy-now).
    public let salesFormat: Int?
    public let quantity: Int?
    public let startPrice: Decimal?
    public let minPrice: Decimal?
    public let buyNowPrice: Decimal?
    public let bestPrice: Decimal?
    public let cost: Decimal?
    public let binds: Int?
    public let views: Int?
    public let finished: Bool?
    public let startTime: String?
    public let endTime: String?
    public let statusTime: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.auctionId = try container.decodeInt(forKey: .auctionId)
        self.auctionHouseId = try container.decodeIntIfPresent(forKey: .auctionHouseId)
        self.productId = try container.decodeIntIfPresent(forKey: .productId)
        self.stockId = try container.decodeIntIfPresent(forKey: .stockId)
        self.realAuctionId = try container.decodeIfPresent(String.self, forKey: .realAuctionId)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.salesFormat = try container.decodeIntIfPresent(forKey: .salesFormat)
        self.quantity = try container.decodeIntIfPresent(forKey: .quantity)
        self.startPrice = try container.decodeDecimalIfPresent(forKey: .startPrice)
        self.minPrice = try container.decodeDecimalIfPresent(forKey: .minPrice)
        self.buyNowPrice = try container.decodeDecimalIfPresent(forKey: .buyNowPrice)
        self.bestPrice = try container.decodeDecimalIfPresent(forKey: .bestPrice)
        self.cost = try container.decodeDecimalIfPresent(forKey: .cost)
        self.binds = try container.decodeIntIfPresent(forKey: .binds)
        self.views = try container.decodeIntIfPresent(forKey: .views)
        self.finished = try container.decodeBoolIfPresent(forKey: .finished)
        self.startTime = try container.decodeDateStringIfPresent(forKey: .startTime)
        self.endTime = try container.decodeDateStringIfPresent(forKey: .endTime)
        self.statusTime = try container.decodeDateStringIfPresent(forKey: .statusTime)
    }

    enum CodingKeys: CodingKey {
        case auctionId
        case auctionHouseId
        case productId
        case stockId
        case realAuctionId
        case title
        case salesFormat
        case quantity
        case startPrice
        case minPrice
        case buyNowPrice
        case bestPrice
        case cost
        case binds
        case views
        case finished
        case startTime
        case endTime
        case statusTime
    }
}

extension Auction: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateAuction
    public typealias UpdatePayload = UpdateAuction

    public var id: Identifier { .id(auctionId) }
    public static var endpoint: Endpoint { .auctions }
}
