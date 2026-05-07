import Foundation

public struct ShopOrder: Codable {
    public let orderId: Int?
    public let userId: Int?
    public let date: String?
    public let statusDate: String?
    public let confirmDate: String?
    public let statusId: Int?
    public let paymentId: Int?
    public let shippingId: Int?
    public let sum: Decimal?
    public let currencyId: Int?
    public let paid: Bool?
    public let email: String?
    public let deliveryCode: String?
    public let deliveryPrice: Decimal?
    public let deliveryWeight: Decimal?
    public let deliveryFullname: String?
    public let deliveryCompany: String?
    public let deliveryAddress: String?
    public let deliveryPostcode: String?
    public let deliveryCity: String?
    public let deliveryCountry: String?
    public let deliveryCountryCode: String?
    public let billingFullname: String?
    public let billingCompany: String?
    public let billingNip: String?
    public let billingAddress: String?
    public let billingPostcode: String?
    public let billingCity: String?
    public let billingCountry: String?
    public let billingCountryCode: String?
    public let phone: String?
    public let note: String?
    public let adminNote: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decodeIntIfPresent(forKey: .orderId)
        self.userId = try container.decodeIntIfPresent(forKey: .userId)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.statusDate = try container.decodeIfPresent(String.self, forKey: .statusDate)
        self.confirmDate = try container.decodeIfPresent(String.self, forKey: .confirmDate)
        self.statusId = try container.decodeIntIfPresent(forKey: .statusId)
        self.paymentId = try container.decodeIntIfPresent(forKey: .paymentId)
        self.shippingId = try container.decodeIntIfPresent(forKey: .shippingId)
        self.sum = try container.decodeDecimalIfPresent(forKey: .sum)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.paid = try container.decodeBoolIfPresent(forKey: .paid)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.deliveryCode = try container.decodeIfPresent(String.self, forKey: .deliveryCode)
        self.deliveryPrice = try container.decodeDecimalIfPresent(forKey: .deliveryPrice)
        self.deliveryWeight = try container.decodeDecimalIfPresent(forKey: .deliveryWeight)
        self.deliveryFullname = try container.decodeIfPresent(String.self, forKey: .deliveryFullname)
        self.deliveryCompany = try container.decodeIfPresent(String.self, forKey: .deliveryCompany)
        self.deliveryAddress = try container.decodeIfPresent(String.self, forKey: .deliveryAddress)
        self.deliveryPostcode = try container.decodeIfPresent(String.self, forKey: .deliveryPostcode)
        self.deliveryCity = try container.decodeIfPresent(String.self, forKey: .deliveryCity)
        self.deliveryCountry = try container.decodeIfPresent(String.self, forKey: .deliveryCountry)
        self.deliveryCountryCode = try container.decodeIfPresent(String.self, forKey: .deliveryCountryCode)
        self.billingFullname = try container.decodeIfPresent(String.self, forKey: .billingFullname)
        self.billingCompany = try container.decodeIfPresent(String.self, forKey: .billingCompany)
        self.billingNip = try container.decodeIfPresent(String.self, forKey: .billingNip)
        self.billingAddress = try container.decodeIfPresent(String.self, forKey: .billingAddress)
        self.billingPostcode = try container.decodeIfPresent(String.self, forKey: .billingPostcode)
        self.billingCity = try container.decodeIfPresent(String.self, forKey: .billingCity)
        self.billingCountry = try container.decodeIfPresent(String.self, forKey: .billingCountry)
        self.billingCountryCode = try container.decodeIfPresent(String.self, forKey: .billingCountryCode)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.note = try container.decodeIfPresent(String.self, forKey: .note)
        self.adminNote = try container.decodeIfPresent(String.self, forKey: .adminNote)
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
