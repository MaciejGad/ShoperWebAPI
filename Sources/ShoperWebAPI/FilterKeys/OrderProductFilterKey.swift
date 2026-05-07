import Foundation

public struct OrderProductFilterKey: FilterKey {
    public let rawValue: String

    public enum Parameter: String {
        /// order product identifier
        case orderProductId = "order_product_id"
        /// order identifier
        case orderId = "order_id"
        /// product identifier
        case productId = "product_id"
        /// stock identifier
        case stockId = "stock_id"
        /// product name at time of purchase
        case name = "name"
        /// product code
        case code = "code"
        /// ordered quantity
        case quantity = "quantity"
        /// unit price (net)
        case price = "price"
        /// unit price (gross)
        case priceBrutto = "price_brutto"
        /// tax identifier
        case taxId = "tax_id"
        /// currency identifier
        case currencyId = "currency_id"
        /// product type
        case productType = "product_type"
        /// measurement unit identifier
        case unitId = "unit_id"
    }

    public static func parameter(_ parameter: Parameter) -> OrderProductFilterKey {
        return OrderProductFilterKey(rawValue: parameter.rawValue)
    }
}

extension Filter where Key == OrderProductFilterKey {
    public static func orderId(_ value: Int) -> Filter<Key> {
        return .init(key: .parameter(.orderId), value: .equal("\(value)"))
    }

    public static func productId(_ value: Int) -> Filter<Key> {
        return .init(key: .parameter(.productId), value: .equal("\(value)"))
    }
}
