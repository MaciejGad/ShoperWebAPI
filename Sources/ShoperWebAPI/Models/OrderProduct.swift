import Foundation

public struct OrderProduct: Codable {
    public let orderProductId: Int?
    public let orderId: Int?
    public let productId: Int?
    public let stockId: Int?
    public let name: String?
    public let code: String?
    public let quantity: Decimal?
    public let price: Decimal?
    public let priceBrutto: Decimal?
    public let priceBuying: Decimal?
    public let priceTaxValue: Decimal?
    public let taxId: Int?
    public let currencyRate: Decimal?
    public let currencyId: Int?
    public let currencyName: String?
    public let productType: Int?
    public let gaugeWeight: Decimal?
    public let unitId: Int?
    public let rebate: Decimal?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderProductId = try container.decodeIntIfPresent(forKey: .orderProductId)
        self.orderId = try container.decodeIntIfPresent(forKey: .orderId)
        self.productId = try container.decodeIntIfPresent(forKey: .productId)
        self.stockId = try container.decodeIntIfPresent(forKey: .stockId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.quantity = try container.decodeDecimalIfPresent(forKey: .quantity)
        self.price = try container.decodeDecimalIfPresent(forKey: .price)
        self.priceBrutto = try container.decodeDecimalIfPresent(forKey: .priceBrutto)
        self.priceBuying = try container.decodeDecimalIfPresent(forKey: .priceBuying)
        self.priceTaxValue = try container.decodeDecimalIfPresent(forKey: .priceTaxValue)
        self.taxId = try container.decodeIntIfPresent(forKey: .taxId)
        self.currencyRate = try container.decodeDecimalIfPresent(forKey: .currencyRate)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.currencyName = try container.decodeIfPresent(String.self, forKey: .currencyName)
        self.productType = try container.decodeIntIfPresent(forKey: .productType)
        self.gaugeWeight = try container.decodeDecimalIfPresent(forKey: .gaugeWeight)
        self.unitId = try container.decodeIntIfPresent(forKey: .unitId)
        self.rebate = try container.decodeDecimalIfPresent(forKey: .rebate)
    }
}

extension OrderProduct: Resource {
    public typealias Key = OrderProductFilterKey
    public typealias CreatePayload = CreateOrderProduct
    public typealias UpdatePayload = UpdateOrderProduct
    public typealias Sort = OrderProductSortKey

    public var id: Identifier {
        return orderProductId.map { Identifier.id($0) } ?? .none
    }

    public static var endpoint: Endpoint {
        .orderProducts
    }
}
