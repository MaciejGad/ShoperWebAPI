import Foundation

/// A special offer record from the standalone `/specialoffers` endpoint.
/// Not to be confused with `SpecialOffer`, the nested read-only summary embedded in `Stock`/`ProductStock`.
public struct ProductSpecialOffer: Decodable, Sendable {
    public let promoId: Int
    public let productId: Int
    public let stockId: Int?
    /// 1 - whole product with all options, 2 - just defined options.
    public let conditionType: Int?
    public let dateFrom: String?
    public let dateTo: String?
    public let discount: Decimal?
    public let discountSpecial: Decimal?
    public let discountWholesale: Decimal?
    /// 1 - deprecated, 2 - discount by amount, 3 - percentage discount.
    public let discountType: Int?
    public let stocks: [Int]?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.promoId = try container.decodeInt(forKey: .promoId)
        self.productId = try container.decodeInt(forKey: .productId)
        self.stockId = try container.decodeIntIfPresent(forKey: .stockId)
        self.conditionType = try container.decodeIntIfPresent(forKey: .conditionType)
        self.dateFrom = try container.decodeIfPresent(String.self, forKey: .dateFrom)
        self.dateTo = try container.decodeIfPresent(String.self, forKey: .dateTo)
        self.discount = try container.decodeDecimalIfPresent(forKey: .discount)
        self.discountSpecial = try container.decodeDecimalIfPresent(forKey: .discountSpecial)
        self.discountWholesale = try container.decodeDecimalIfPresent(forKey: .discountWholesale)
        self.discountType = try container.decodeIntIfPresent(forKey: .discountType)
        self.stocks = try container.decodeIntArrayIfPresent(forKey: .stocks)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case promoId
        case productId
        case stockId
        case conditionType
        case dateFrom
        case dateTo
        case discount
        case discountSpecial
        case discountWholesale
        case discountType
        case stocks
    }
}

extension ProductSpecialOffer: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(promoId) }
    public static var endpoint: Endpoint { .specialOffers }
}
