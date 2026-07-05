import Foundation

public struct CreateAuctionOrder: Encodable, Sendable {
    public var orderId: Int
    public var auctionId: Int?
    public var auctionHouseId: Int?
    public var buyerId: Int?
    public var buyerLogin: String?
    public var dealId: String?
    public var realAuctionId: String?
    public var paymentMethod: String?
    public var paymentTime: String?
    public var shipmentMethod: String?
    public var statusTime: String?
    public var transactionId: String?

    public init(
        orderId: Int,
        auctionId: Int? = nil,
        auctionHouseId: Int? = nil,
        buyerId: Int? = nil,
        buyerLogin: String? = nil,
        dealId: String? = nil,
        realAuctionId: String? = nil,
        paymentMethod: String? = nil,
        paymentTime: String? = nil,
        shipmentMethod: String? = nil,
        statusTime: String? = nil,
        transactionId: String? = nil
    ) {
        self.orderId = orderId
        self.auctionId = auctionId
        self.auctionHouseId = auctionHouseId
        self.buyerId = buyerId
        self.buyerLogin = buyerLogin
        self.dealId = dealId
        self.realAuctionId = realAuctionId
        self.paymentMethod = paymentMethod
        self.paymentTime = paymentTime
        self.shipmentMethod = shipmentMethod
        self.statusTime = statusTime
        self.transactionId = transactionId
    }
}
