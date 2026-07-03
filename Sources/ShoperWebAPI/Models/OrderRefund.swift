import Foundation

/// Requires special app permissions — the `/order-refunds` endpoint is marked internal in the
/// OpenAPI spec ("Resources available for selected applications"). Expect HTTP 403 unless your
/// access token has been granted this scope.
public struct OrderRefund: Decodable, Sendable {
    public let refundId: Int
    public let transactionId: Int
    public let currencyId: Int?
    public let currencyValue: Decimal
    /// Refund status: 1 - pending, 2 - canceled, 3 - finished, 4 - failed.
    public let status: Int
    public let statusDescription: String?
    public let comment: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.refundId = try container.decodeInt(forKey: .refundId)
        self.transactionId = try container.decodeInt(forKey: .transactionId)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.currencyValue = try container.decodeDecimal(forKey: .currencyValue)
        self.status = try container.decodeInt(forKey: .status)
        self.statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case refundId
        case transactionId
        case currencyId
        case currencyValue
        case status
        case statusDescription
        case comment
    }
}

extension OrderRefund: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(refundId) }
    public static var endpoint: Endpoint { .orderRefunds }
}
