import Foundation

/// Requires special app permissions — the `/order-transactions` endpoint is marked internal in
/// the OpenAPI spec ("Resources available for selected applications"). Expect HTTP 403 unless
/// your access token has been granted this scope.
///
/// Note: the OpenAPI schema for `OrderTransaction` does not document an id property in its
/// properties list, even though `/order-transactions/{id}` exists. The exact wire key for the
/// identifier is unconfirmed without access to a token that has this scope granted.
public struct OrderTransaction: Decodable, Sendable {
    public let transactionId: Int
    public let orderId: Int
    public let paymentId: Int
    public let currencyId: Int?
    public let currencyValue: Decimal
    public let date: String?
    public let refundId: Int?
    /// Transaction status: 1 - pending, 2 - canceled, 3 - finished, 4 - failed.
    public let status: Int
    public let statusDescription: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactionId = try container.decodeInt(forKey: .transactionId)
        self.orderId = try container.decodeInt(forKey: .orderId)
        self.paymentId = try container.decodeInt(forKey: .paymentId)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.currencyValue = try container.decodeDecimal(forKey: .currencyValue)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.refundId = try container.decodeIntIfPresent(forKey: .refundId)
        self.status = try container.decodeInt(forKey: .status)
        self.statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case transactionId
        case orderId
        case paymentId
        case currencyId
        case currencyValue
        case date
        case refundId
        case status
        case statusDescription
    }
}

extension OrderTransaction: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(transactionId) }
    public static var endpoint: Endpoint { .orderTransactions }
}
