import Foundation

/// Links a shop `ShopOrder` to the marketplace/auction system's own order record.
///
/// Note: the OpenAPI spec only documents `GET /auction-orders` (list), `POST /auction-orders`
/// (create), `GET /auction-orders/{id}` (get), `PUT /auction-orders/{id}` (update) — no `DELETE`.
/// `Resource.delete` is still available since the protocol requires it, but calling it will 404
/// against the real API.
public struct AuctionOrder: Decodable, Sendable {
    public let auctionOrderId: Int
    public let orderId: Int?
    public let auctionId: Int?
    public let auctionHouseId: Int?
    public let buyerId: Int?
    public let buyerLogin: String?
    public let dealId: String?
    public let realAuctionId: String?
    public let paymentMethod: String?
    public let paymentTime: String?
    public let shipmentMethod: String?
    public let statusTime: String?
    public let transactionId: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.auctionOrderId = try container.decodeInt(forKey: .auctionOrderId)
        self.orderId = try container.decodeIntIfPresent(forKey: .orderId)
        self.auctionId = try container.decodeIntIfPresent(forKey: .auctionId)
        self.auctionHouseId = try container.decodeIntIfPresent(forKey: .auctionHouseId)
        self.buyerId = try container.decodeIntIfPresent(forKey: .buyerId)
        self.buyerLogin = try container.decodeIfPresent(String.self, forKey: .buyerLogin)
        self.dealId = try container.decodeIfPresent(String.self, forKey: .dealId)
        self.realAuctionId = try container.decodeIfPresent(String.self, forKey: .realAuctionId)
        self.paymentMethod = try container.decodeIfPresent(String.self, forKey: .paymentMethod)
        self.paymentTime = try container.decodeDateStringIfPresent(forKey: .paymentTime)
        self.shipmentMethod = try container.decodeIfPresent(String.self, forKey: .shipmentMethod)
        self.statusTime = try container.decodeDateStringIfPresent(forKey: .statusTime)
        self.transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
    }

    enum CodingKeys: CodingKey {
        case auctionOrderId
        case orderId
        case auctionId
        case auctionHouseId
        case buyerId
        case buyerLogin
        case dealId
        case realAuctionId
        case paymentMethod
        case paymentTime
        case shipmentMethod
        case statusTime
        case transactionId
    }
}

extension AuctionOrder: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateAuctionOrder
    public typealias UpdatePayload = UpdateAuctionOrder

    public var id: Identifier { .id(auctionOrderId) }
    public static var endpoint: Endpoint { .auctionOrders }
}
