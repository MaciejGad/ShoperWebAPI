import Foundation

public struct UpdateSubscriberGroup: Encodable, Sendable {
    public var name: String?
    public var autoAdd: Bool?

    public init(name: String? = nil, autoAdd: Bool? = nil) {
        self.name = name
        self.autoAdd = autoAdd
    }
}
