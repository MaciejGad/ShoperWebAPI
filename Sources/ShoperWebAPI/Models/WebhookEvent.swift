import Foundation

/// One of the 24 documented webhook events across seven resource groups (per the dedicated
/// "Shoper Webhooks" OpenAPI description, not the main API spec — the main spec's `Webhook`
/// schema just says `events: [string]` with no enumeration).
///
/// `events` is validated server-side against this whitelist: an unrecognized value is rejected
/// with HTTP 400 ("nie została znaleziona na liście"), confirmed live by testing
/// `"order.created"` (rejected — no `-ed` suffix in this API) vs `"order.create"` (accepted).
///
/// Note: live stores may have additional webhooks (created by installed AppStore apps) using
/// event names outside this list — e.g. `"admin.account_connected"`, `"order_transaction.create"`,
/// `"order_refund.create"` were observed on a real store. These decode fine via `.unknown(String)`;
/// they appear to be reserved for system/app-installed webhooks rather than generally creatable.
public enum WebhookEvent: Equatable, Sendable {
    // Categories
    case categoryCreate
    case categoryEdit
    case categoryDelete
    // Orders
    case orderCreate
    case orderEdit
    case orderPaid
    case orderStatus
    case orderDelete
    // Clients
    case clientCreate
    case clientEdit
    case clientDelete
    // Products
    case productCreate
    case productEdit
    case productDelete
    // Parcels
    case parcelCreate
    case parcelDispatch
    case parcelDelete
    case parcelSend
    // Special Offers
    case specialOfferCreate
    case specialOfferEdit
    case specialOfferDelete
    // Subscribers
    case subscriberCreate
    case subscriberEdit
    case subscriberDelete
    /// A value returned by (or accepted by) the API that isn't one of the 24 documented events —
    /// e.g. events reserved for system/AppStore-installed webhooks.
    case unknown(String)

    public init(rawValue: String) {
        switch rawValue {
        case "category.create": self = .categoryCreate
        case "category.edit": self = .categoryEdit
        case "category.delete": self = .categoryDelete
        case "order.create": self = .orderCreate
        case "order.edit": self = .orderEdit
        case "order.paid": self = .orderPaid
        case "order.status": self = .orderStatus
        case "order.delete": self = .orderDelete
        case "client.create": self = .clientCreate
        case "client.edit": self = .clientEdit
        case "client.delete": self = .clientDelete
        case "product.create": self = .productCreate
        case "product.edit": self = .productEdit
        case "product.delete": self = .productDelete
        case "parcel.create": self = .parcelCreate
        case "parcel.dispatch": self = .parcelDispatch
        case "parcel.delete": self = .parcelDelete
        case "parcel.send": self = .parcelSend
        case "specialoffer.create": self = .specialOfferCreate
        case "specialoffer.edit": self = .specialOfferEdit
        case "specialoffer.delete": self = .specialOfferDelete
        case "subscriber.create": self = .subscriberCreate
        case "subscriber.edit": self = .subscriberEdit
        case "subscriber.delete": self = .subscriberDelete
        default: self = .unknown(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .categoryCreate: return "category.create"
        case .categoryEdit: return "category.edit"
        case .categoryDelete: return "category.delete"
        case .orderCreate: return "order.create"
        case .orderEdit: return "order.edit"
        case .orderPaid: return "order.paid"
        case .orderStatus: return "order.status"
        case .orderDelete: return "order.delete"
        case .clientCreate: return "client.create"
        case .clientEdit: return "client.edit"
        case .clientDelete: return "client.delete"
        case .productCreate: return "product.create"
        case .productEdit: return "product.edit"
        case .productDelete: return "product.delete"
        case .parcelCreate: return "parcel.create"
        case .parcelDispatch: return "parcel.dispatch"
        case .parcelDelete: return "parcel.delete"
        case .parcelSend: return "parcel.send"
        case .specialOfferCreate: return "specialoffer.create"
        case .specialOfferEdit: return "specialoffer.edit"
        case .specialOfferDelete: return "specialoffer.delete"
        case .subscriberCreate: return "subscriber.create"
        case .subscriberEdit: return "subscriber.edit"
        case .subscriberDelete: return "subscriber.delete"
        case .unknown(let value): return value
        }
    }
}

extension WebhookEvent: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(rawValue: stringValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
