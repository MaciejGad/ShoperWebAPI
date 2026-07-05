import Foundation

public struct UpdateNewsTag: Encodable, Sendable {
    public var name: String?
    public var langId: Int?

    public init(name: String? = nil, langId: Int? = nil) {
        self.name = name
        self.langId = langId
    }
}
