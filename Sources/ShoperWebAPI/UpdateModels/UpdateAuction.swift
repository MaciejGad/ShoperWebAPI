import Foundation

public struct UpdateAuction: Encodable, Sendable {
    public var auctionHouseId: Int?
    public var realAuctionId: String?
    public var title: String?
    /// `0` - bidding, `1` - immediate (buy-now).
    public var salesFormat: Int?
    public var productId: Int?
    public var quantity: Int?
    public var stockId: Int?
    public var startPrice: Decimal?
    public var minPrice: Decimal?
    public var buyNowPrice: Decimal?
    public var bestPrice: Decimal?
    public var cost: Decimal?
    public var binds: Int?
    public var views: Int?
    public var finished: Bool?
    public var startTime: String?
    public var endTime: String?
    public var statusTime: String?

    public init(
        auctionHouseId: Int? = nil,
        realAuctionId: String? = nil,
        title: String? = nil,
        salesFormat: Int? = nil,
        productId: Int? = nil,
        quantity: Int? = nil,
        stockId: Int? = nil,
        startPrice: Decimal? = nil,
        minPrice: Decimal? = nil,
        buyNowPrice: Decimal? = nil,
        bestPrice: Decimal? = nil,
        cost: Decimal? = nil,
        binds: Int? = nil,
        views: Int? = nil,
        finished: Bool? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        statusTime: String? = nil
    ) {
        self.auctionHouseId = auctionHouseId
        self.realAuctionId = realAuctionId
        self.title = title
        self.salesFormat = salesFormat
        self.productId = productId
        self.quantity = quantity
        self.stockId = stockId
        self.startPrice = startPrice
        self.minPrice = minPrice
        self.buyNowPrice = buyNowPrice
        self.bestPrice = bestPrice
        self.cost = cost
        self.binds = binds
        self.views = views
        self.finished = finished
        self.startTime = startTime
        self.endTime = endTime
        self.statusTime = statusTime
    }
}
