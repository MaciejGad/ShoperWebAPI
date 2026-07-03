import Foundation

public struct CreateUserTag: Encodable, Sendable {
    public var name: String
    public var langId: Int

    public init(name: String, langId: Int) {
        self.name = name
        self.langId = langId
    }
}
