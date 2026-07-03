import Foundation

public struct Parcel: Decodable, Sendable {
    public let parcelId: Int
    public let orderId: Int?
    public let shippingId: Int?
    public let shippingCode: String?
    public let weight: Decimal?
    public let cod: Bool?
    public let codCost: Decimal?
    public let insurance: Bool?
    public let insuranceCost: Decimal?
    public let notes: String?
    public let warehouseId: Int?
    public let orderDate: String?
    public let sendDate: String?
    public let deliveryDate: String?
    public let sent: Bool?
    /// 0 - not connected with a parcel delivery company, 1 - connected via API integration.
    public let online: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.parcelId = try container.decodeInt(forKey: .parcelId)
        self.orderId = try container.decodeIntIfPresent(forKey: .orderId)
        self.shippingId = try container.decodeIntIfPresent(forKey: .shippingId)
        self.shippingCode = try container.decodeIfPresent(String.self, forKey: .shippingCode)
        self.weight = try container.decodeDecimalIfPresent(forKey: .weight)
        self.cod = try container.decodeBoolIfPresent(forKey: .cod)
        self.codCost = try container.decodeDecimalIfPresent(forKey: .codCost)
        self.insurance = try container.decodeBoolIfPresent(forKey: .insurance)
        self.insuranceCost = try container.decodeDecimalIfPresent(forKey: .insuranceCost)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.warehouseId = try container.decodeIntIfPresent(forKey: .warehouseId)
        self.orderDate = try container.decodeIfPresent(String.self, forKey: .orderDate)
        self.sendDate = try container.decodeIfPresent(String.self, forKey: .sendDate)
        self.deliveryDate = try container.decodeIfPresent(String.self, forKey: .deliveryDate)
        self.sent = try container.decodeBoolIfPresent(forKey: .sent)
        self.online = try container.decodeBoolIfPresent(forKey: .online)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case parcelId
        case orderId
        case shippingId
        case shippingCode
        case weight
        case cod
        case codCost
        case insurance
        case insuranceCost
        case notes
        case warehouseId
        case orderDate
        case sendDate
        case deliveryDate
        case sent
        case online
    }
}

extension Parcel: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(parcelId) }
    public static var endpoint: Endpoint { .parcels }
}
