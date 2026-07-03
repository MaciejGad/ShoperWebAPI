import Foundation

public struct CreateSubscriberGroup: Encodable, Sendable {
    public var name: String
    public var autoAdd: Bool?

    public init(name: String, autoAdd: Bool? = nil) {
        self.name = name
        self.autoAdd = autoAdd
    }
}
