import Foundation

struct ProductChild: Codable {
    let id: Int
    let bundleId: Int
    let stockId: Int
    let productId: Int
    let stock: Decimal
    let order: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeInt(forKey: .id)
        self.bundleId = try container.decodeInt(forKey: .bundleId)
        self.stockId = try container.decodeInt(forKey: .stockId)
        self.productId = try container.decodeInt(forKey: .productId)
        self.stock = try container.decodeDecimal(forKey: .stock)
        self.order = try container.decodeInt(forKey: .order)
    }
}
