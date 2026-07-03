import Foundation

public struct UpdateWebhook: Encodable, Sendable {
    public var url: String?
    public var format: WebhookFormat?
    public var active: Bool?
    public var events: [WebhookEvent]?
    public var secret: String?

    public init(
        url: String? = nil,
        format: WebhookFormat? = nil,
        active: Bool? = nil,
        events: [WebhookEvent]? = nil,
        secret: String? = nil
    ) {
        self.url = url
        self.format = format
        self.active = active
        self.events = events
        self.secret = secret
    }
}
