import Foundation

public struct UpdateStock: Codable {
    /// a price or its difference to the basic stock price (always greater than 0)
    public let price: Decimal?
    
    /// stock availability - if warehouses is enabled field is read only and includes the sum of all warehouses
    public let stock: Decimal?
    
    /// stock availability warning level
    public let warnLevel: Decimal?
    
    /// sold items count
    public let sold: Decimal?
    
    /// weight of the item
    public let weight: Decimal?
    
    public init(price: Decimal? = nil, stock: Decimal? = nil, warnLevel: Decimal? = nil, sold: Decimal? = nil, weight: Decimal? = nil) {
        self.price = price
        self.stock = stock
        self.warnLevel = warnLevel
        self.sold = sold
        self.weight = weight
    }
}
