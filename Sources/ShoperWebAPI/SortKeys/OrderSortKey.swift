import Foundation

/// Sort keys available for order queries
public enum OrderSortKey: SortKey {
    /// Order identifier
    case orderId
    /// Customer identifier
    case userId
    /// Order placement date
    case date
    /// Last status change date
    case statusDate
    /// Order confirmation date
    case confirmDate
    /// Order status identifier
    case statusId
    /// Payment method identifier
    case paymentId
    /// Shipping method identifier
    case shippingId
    /// Order total value
    case sum
    /// Is order paid
    case paid
    /// Object creation datetime in ISO_8601 format
    case createdAt
    /// Latest object modification datetime in ISO_8601 format
    case updatedAt

    /// Returns the string value for the sort key
    public var rawValue: String {
        switch self {
        case .orderId: return "order_id"
        case .userId: return "user_id"
        case .date: return "date"
        case .statusDate: return "status_date"
        case .confirmDate: return "confirm_date"
        case .statusId: return "status_id"
        case .paymentId: return "payment_id"
        case .shippingId: return "shipping_id"
        case .sum: return "sum"
        case .paid: return "paid"
        case .createdAt: return "created_at"
        case .updatedAt: return "updated_at"
        }
    }
}

extension Order where Key == OrderSortKey {
    public static func date(direction: SortDirection = .descending) -> Order<Key> {
        return .init(.date, direction)
    }

    public static func orderId(direction: SortDirection = .ascending) -> Order<Key> {
        return .init(.orderId, direction)
    }

    public static func sum(direction: SortDirection = .descending) -> Order<Key> {
        return .init(.sum, direction)
    }
}
