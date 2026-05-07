import Foundation

public struct ShopOrder: Codable {
    public let orderId: Int?
    public let userId: Int?
    public let date: String?
    public let statusDate: String?
    public let confirmDate: String?
    public let deliveryDate: String?
    public let statusId: Int?
    public let sum: Decimal?
    public let paymentId: Int?
    public let userOrder: Int?
    public let shippingId: Int?
    public let shippingCost: Decimal?
    public let email: String?
    public let deliveryCode: String?
    public let code: String?
    public let confirm: Int?
    public let notes: String?
    public let notesPriv: String?
    public let notesPub: String?
    public let currencyId: Int?
    public let currencyRate: Decimal?
    public let paid: Decimal?
    public let ipAddress: String?
    public let discountClient: Decimal?
    public let discountGroup: Decimal?
    public let discountLevels: Decimal?
    public let discountCode: Decimal?
    public let codeId: Int?
    public let langId: Int?
    public let origin: Int?
    public let parentOrderId: Int?
    public let registered: Int?
    public let deliveryEmail: String?
    public let promoCode: String?
    public let additionalFields: [OrderAdditionalField]?
    public let pickupPoint: String?
    public let pickupPointData: PickupPointData?
    public let shippingAdditionalFields: [String: String]?
    public let properties: [String]?
    public let tags: [String]?
    public let orderUrl: String?
    public let paymentUrl: String?
    public let isCashOnDelivery: Bool?
    public let isPaid: Bool?
    public let isOverpayment: Bool?
    public let isUnderpayment: Bool?
    public let totalParcels: Int?
    public let totalProducts: Int?
    public let children: [Int]?
    public let loyaltyCost: Decimal?
    public let loyaltyScore: Int?
    public let vatEu: Bool?
    public let shippingTaxName: String?
    public let shippingTaxValue: Decimal?
    public let shippingTaxId: Int?
    public let deliveryAddress: OrderAddress?
    public let billingAddress: OrderAddress?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decodeIntIfPresent(forKey: .orderId)
        self.userId = try container.decodeIntIfPresent(forKey: .userId)
        self.date = try container.decodeDateStringIfPresent(forKey: .date)
        self.statusDate = try container.decodeDateStringIfPresent(forKey: .statusDate)
        self.confirmDate = try container.decodeDateStringIfPresent(forKey: .confirmDate)
        self.deliveryDate = try container.decodeDateStringIfPresent(forKey: .deliveryDate)
        self.statusId = try container.decodeIntIfPresent(forKey: .statusId)
        self.sum = try container.decodeDecimalIfPresent(forKey: .sum)
        self.paymentId = try container.decodeIntIfPresent(forKey: .paymentId)
        self.userOrder = try container.decodeIntIfPresent(forKey: .userOrder)
        self.shippingId = try container.decodeIntIfPresent(forKey: .shippingId)
        self.shippingCost = try container.decodeDecimalIfPresent(forKey: .shippingCost)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.deliveryCode = try container.decodeIfPresent(String.self, forKey: .deliveryCode)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.confirm = try container.decodeIntIfPresent(forKey: .confirm)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.notesPriv = try container.decodeIfPresent(String.self, forKey: .notesPriv)
        self.notesPub = try container.decodeIfPresent(String.self, forKey: .notesPub)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.currencyRate = try container.decodeDecimalIfPresent(forKey: .currencyRate)
        self.paid = try container.decodeDecimalIfPresent(forKey: .paid)
        self.ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress)
        self.discountClient = try container.decodeDecimalIfPresent(forKey: .discountClient)
        self.discountGroup = try container.decodeDecimalIfPresent(forKey: .discountGroup)
        self.discountLevels = try container.decodeDecimalIfPresent(forKey: .discountLevels)
        self.discountCode = try container.decodeDecimalIfPresent(forKey: .discountCode)
        self.codeId = try container.decodeIntIfPresent(forKey: .codeId)
        self.langId = try container.decodeIntIfPresent(forKey: .langId)
        self.origin = try container.decodeIntIfPresent(forKey: .origin)
        self.parentOrderId = try container.decodeIntIfPresent(forKey: .parentOrderId)
        self.registered = try container.decodeIntIfPresent(forKey: .registered)
        self.deliveryEmail = try container.decodeIfPresent(String.self, forKey: .deliveryEmail)
        self.promoCode = try container.decodeIfPresent(String.self, forKey: .promoCode)
        self.additionalFields = try container.decodeIfPresent([OrderAdditionalField].self, forKey: .additionalFields)
        self.pickupPoint = try container.decodeIfPresent(String.self, forKey: .pickupPoint)
        self.pickupPointData = try container.decodeIfPresent(PickupPointData.self, forKey: .pickupPointData)
        self.shippingAdditionalFields = try container.decodeIfPresent([String: String].self, forKey: .shippingAdditionalFields)
        self.properties = try container.decodeIfPresent([String].self, forKey: .properties)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
        self.orderUrl = try container.decodeIfPresent(String.self, forKey: .orderUrl)
        self.paymentUrl = try container.decodeIfPresent(String.self, forKey: .paymentUrl)
        self.isCashOnDelivery = try container.decodeBoolIfPresent(forKey: .isCashOnDelivery)
        self.isPaid = try container.decodeBoolIfPresent(forKey: .isPaid)
        self.isOverpayment = try container.decodeBoolIfPresent(forKey: .isOverpayment)
        self.isUnderpayment = try container.decodeBoolIfPresent(forKey: .isUnderpayment)
        self.totalParcels = try container.decodeIntIfPresent(forKey: .totalParcels)
        self.totalProducts = try container.decodeIntIfPresent(forKey: .totalProducts)
        self.children = try container.decodeIfPresent([Int].self, forKey: .children)
        self.loyaltyCost = try container.decodeDecimalIfPresent(forKey: .loyaltyCost)
        self.loyaltyScore = try container.decodeIntIfPresent(forKey: .loyaltyScore)
        self.vatEu = try container.decodeBoolIfPresent(forKey: .vatEu)
        self.shippingTaxName = try container.decodeIfPresent(String.self, forKey: .shippingTaxName)
        self.shippingTaxValue = try container.decodeDecimalIfPresent(forKey: .shippingTaxValue)
        self.shippingTaxId = try container.decodeIntIfPresent(forKey: .shippingTaxId)
        self.deliveryAddress = try container.decodeIfPresent(OrderAddress.self, forKey: .deliveryAddress)
        self.billingAddress = try container.decodeIfPresent(OrderAddress.self, forKey: .billingAddress)
    }
}

extension ShopOrder: Resource {
    public typealias Key = OrderFilterKey
    public typealias CreatePayload = CreateOrder
    public typealias UpdatePayload = UpdateOrder
    public typealias Sort = OrderSortKey

    public var id: Identifier {
        return orderId.map { Identifier.id($0) } ?? .none
    }

    public static var endpoint: Endpoint {
        .orders
    }
}
