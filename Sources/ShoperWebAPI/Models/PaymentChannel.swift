import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A payment channel nested under a `Payment` (`/payments/{payment_id}/channels`). Doesn't
/// conform to `Resource` since the endpoint requires a `paymentId` alongside the usual `id`.
///
/// Note: the OpenAPI spec describes this resource as "available for selected applications" —
/// like `OrderRefund`/`OrderTransaction`, expect HTTP 403 on a standard token unless Shoper has
/// granted the app this scope (contact appstore@shoper.pl).
public struct PaymentChannel: Decodable, Sendable {
    public let channelId: Int
    public let paymentId: Int
    /// Nullable numeric-string id of the channel on the application's side.
    public let applicationChannelId: String?
    public let channelKey: String?
    public let currencies: [String]?
    public let type: String?
    public let translations: [String: PaymentChannelTranslation]

    public struct PaymentChannelTranslation: Decodable, Sendable {
        public let name: String?
        public let description: String?
        public let additionalInfoLabel: String?
        public let imageUrl: String?
        public let active: Bool?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.additionalInfoLabel = try container.decodeIfPresent(String.self, forKey: .additionalInfoLabel)
            self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
            self.active = try container.decodeBoolIfPresent(forKey: .active)
        }

        enum CodingKeys: CodingKey {
            case name
            case description
            case additionalInfoLabel
            case imageUrl
            case active
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try container.decodeInt(forKey: .channelId)
        self.paymentId = try container.decodeInt(forKey: .paymentId)
        self.applicationChannelId = try container.decodeIfPresent(String.self, forKey: .applicationChannelId)
        self.channelKey = try container.decodeIfPresent(String.self, forKey: .channelKey)
        self.currencies = try container.decodeIfPresent([String].self, forKey: .currencies)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.translations = (try? container.decode([String: PaymentChannelTranslation].self, forKey: .translations)) ?? [:]
    }

    enum CodingKeys: CodingKey {
        case channelId
        case paymentId
        case applicationChannelId
        case channelKey
        case currencies
        case type
        case translations
    }

    public static func list(client: ClientProtocol, paymentId: Int, page: Int? = nil, limit: Int? = nil) async throws -> NestedResourceList<PaymentChannel> {
        let data = try await client.get(endpoint: .paymentChannels, parentId: paymentId, id: nil, filters: nil, sort: nil, page: page, limit: limit)
        return try client.decode(data: data)
    }

    public static func get(client: ClientProtocol, paymentId: Int, id: Int) async throws -> PaymentChannel {
        let data = try await client.get(endpoint: .paymentChannels, parentId: paymentId, id: id, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }

    public static func create(client: ClientProtocol, paymentId: Int, payload: CreatePaymentChannel) async throws -> Int {
        let data = try await client.post(endpoint: .paymentChannels, parentId: paymentId, payload: payload)
        return try client.decode(data: data)
    }

    public static func update(client: ClientProtocol, paymentId: Int, id: Int, payload: UpdatePaymentChannel) async throws {
        _ = try await client.put(endpoint: .paymentChannels, parentId: paymentId, id: id, payload: payload)
    }

    public static func delete(client: ClientProtocol, paymentId: Int, id: Int) async throws -> Bool {
        do {
            let data = try await client.delete(endpoint: .paymentChannels, parentId: paymentId, id: id)
            let result: Int = try client.decode(data: data)
            return result == 1
        } catch let error as ShoperError {
            if case .invalidResponse(_, let response) = error,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 404 {
                return false
            }
            throw error
        }
    }
}
