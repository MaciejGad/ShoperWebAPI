import Foundation

public struct UpdateSubscriber: Encodable, Sendable {
    public var email: String?
    public var active: Bool?
    public var langId: Int?

    public init(email: String? = nil, active: Bool? = nil, langId: Int? = nil) {
        self.email = email
        self.active = active
        self.langId = langId
    }
}
