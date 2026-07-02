import Foundation

public enum ProductStockSortKey: String, SortKey {
    case stockId = "stock_id"
    case productId = "product_id"
    case code = "code"
    case price = "price"
    case stock = "stock"
}
