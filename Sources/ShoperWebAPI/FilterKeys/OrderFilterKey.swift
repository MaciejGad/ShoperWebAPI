import Foundation

public struct OrderFilterKey: FilterKey {
    public let rawValue: String

    public enum Parameter: String {
        /// order identifier
        case orderId = "order_id"
        /// customer identifier
        case userId = "user_id"
        /// order placement date
        case date = "date"
        /// last status change date
        case statusDate = "status_date"
        /// order confirmation date
        case confirmDate = "confirm_date"
        /// order status identifier
        case statusId = "status_id"
        /// payment method identifier
        case paymentId = "payment_id"
        /// shipping method identifier
        case shippingId = "shipping_id"
        /// order total value
        case sum = "sum"
        /// is order paid
        case paid = "paid"
        /// customer email
        case email = "email"
        /// currency identifier
        case currencyId = "currency_id"
    }

    public static func parameter(_ parameter: Parameter) -> OrderFilterKey {
        return OrderFilterKey(rawValue: parameter.rawValue)
    }
}

extension Filter where Key == OrderFilterKey {
    public static func orderId(_ value: Int) -> Filter<Key> {
        return .init(key: .parameter(.orderId), value: .equal("\(value)"))
    }

    public static func userId(_ value: Int) -> Filter<Key> {
        return .init(key: .parameter(.userId), value: .equal("\(value)"))
    }

    public static func statusId(_ value: Int) -> Filter<Key> {
        return .init(key: .parameter(.statusId), value: .equal("\(value)"))
    }

    public static func email(_ value: String) -> Filter<Key> {
        return .init(key: .parameter(.email), value: .equal(value))
    }

    public static func paid(_ value: Bool) -> Filter<Key> {
        return .init(key: .parameter(.paid), value: .equal(value ? "1" : "0"))
    }
}
