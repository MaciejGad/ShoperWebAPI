import Foundation

public struct Webhook: Decodable, Sendable {
    public let webhookId: Int
    public let url: String?
    public let format: WebhookFormat?
    public let active: Bool?
    public let events: [WebhookEvent]?
    public let secret: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.webhookId = try container.decodeInt(forKey: .webhookId)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.format = try container.decodeIfPresent(WebhookFormat.self, forKey: .format)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.events = try container.decodeIfPresent([WebhookEvent].self, forKey: .events)
        self.secret = try container.decodeIfPresent(String.self, forKey: .secret)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case webhookId
        case url
        case format
        case active
        case events
        case secret
    }
}

extension Webhook: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateWebhook
    public typealias UpdatePayload = UpdateWebhook

    public var id: Identifier { .id(webhookId) }
    public static var endpoint: Endpoint { .webhooks }
}
