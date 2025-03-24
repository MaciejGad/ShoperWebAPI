import Foundation

struct SpecialOffer: Codable {
    let promoId: Int
    let dateFrom: String
    let dateTo: String
    let discount: Decimal
    let discountWholesale: Decimal
    let discountSpecial: Decimal
    let discountType: Int
    let conditionType: Int
    let stocks: [Int]
    
    init(from decoder: any Decoder) throws {
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
