import Foundation

public struct SpecialOffer: Codable, Sendable {
    public let promoId: Int
    public let dateFrom: String
    public let dateTo: String
    public let discount: Decimal
    public let discountWholesale: Decimal
    public let discountSpecial: Decimal
    public let discountType: Int
    public let conditionType: Int
    public let stocks: [Int]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.promoId = try container.decodeInt(forKey: .promoId)
        self.dateFrom = try container.decode(String.self, forKey: .dateFrom)
        self.dateTo = try container.decode(String.self, forKey: .dateTo)
        self.discount = try container.decodeDecimal(forKey: .discount)
        self.discountWholesale = try container.decodeDecimal(forKey: .discountWholesale)
        self.discountSpecial = try container.decodeDecimal(forKey: .discountSpecial)
        self.discountType = try container.decodeInt(forKey: .discountType)
        self.conditionType = try container.decodeInt(forKey: .conditionType)
        self.stocks = try container.decodeIntArray(forKey: .stocks)
    }
}
