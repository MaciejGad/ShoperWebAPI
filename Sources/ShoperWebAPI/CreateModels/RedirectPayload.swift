import Foundation

/// Payload for `/redirects` (`RedirectInsert`/`RedirectUpdate` are structurally identical).
public struct RedirectPayload: Encodable, Sendable {
    public var langId: Int?
    public var objectId: Int?
    public var route: String?
    /// Required if `type` is 0 (own).
    public var target: String?
    public var type: RedirectType?

    public init(
        langId: Int? = nil,
        objectId: Int? = nil,
        route: String? = nil,
        target: String? = nil,
        type: RedirectType? = nil
    ) {
        self.langId = langId
        self.objectId = objectId
        self.route = route
        self.target = target
        self.type = type
    }
}
