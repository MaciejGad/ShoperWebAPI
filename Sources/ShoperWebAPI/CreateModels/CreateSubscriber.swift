import Foundation

public struct CreateSubscriber: Encodable, Sendable {
    public var email: String
    public var active: Bool?
    public var langId: Int?

    public init(email: String, active: Bool? = nil, langId: Int? = nil) {
        self.email = email
        self.active = active
        self.langId = langId
    }
}
