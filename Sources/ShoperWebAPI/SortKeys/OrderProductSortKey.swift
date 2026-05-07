import Foundation

/// Sort keys available for order product queries
public enum OrderProductSortKey: SortKey {
    /// Order product identifier
    case orderProductId
    /// Order identifier
    case orderId
    /// Product identifier
    case productId
    /// Stock identifier
    case stockId
    /// Product name at time of purchase
    case name
    /// Product code
    case code
    /// Ordered quantity
    case quantity
    /// Unit price (net)
    case price
    /// Unit price (gross)
    case priceBrutto
    /// Tax identifier
    case taxId
    /// Currency identifier
    case currencyId
    /// Product type
    case productType
    /// Measurement unit identifier
    case unitId
    /// Object creation datetime in ISO_8601 format
    case createdAt
    /// Latest object modification datetime in ISO_8601 format
    case updatedAt

    /// Returns the string value for the sort key
    public var rawValue: String {
        switch self {
        case .orderProductId: return "order_product_id"
        case .orderId: return "order_id"
        case .productId: return "product_id"
        case .stockId: return "stock_id"
        case .name: return "name"
        case .code: return "code"
        case .quantity: return "quantity"
        case .price: return "price"
        case .priceBrutto: return "price_brutto"
        case .taxId: return "tax_id"
        case .currencyId: return "currency_id"
        case .productType: return "product_type"
        case .unitId: return "unit_id"
        case .createdAt: return "created_at"
        case .updatedAt: return "updated_at"
        }
    }
}

extension Order where Key == OrderProductSortKey {
    public static func orderId(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.orderId, direction)
    }

    public static func price(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.price, direction)
    }

    public static func quantity(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.quantity, direction)
    }
}
