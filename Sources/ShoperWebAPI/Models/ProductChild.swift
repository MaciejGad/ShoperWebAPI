import Foundation

public struct ProductChild: Codable, Sendable {
    public let id: Int
    public let bundleId: Int
    public let stockId: Int
    public let productId: Int
    public let stock: Decimal
    public let order: Int
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeInt(forKey: .id)
        self.bundleId = try container.decodeInt(forKey: .bundleId)
        self.stockId = try container.decodeInt(forKey: .stockId)
        self.productId = try container.decodeInt(forKey: .productId)
        self.stock = try container.decodeDecimal(forKey: .stock)
        self.order = try container.decodeInt(forKey: .order)
    }
}
