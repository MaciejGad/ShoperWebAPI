import Foundation

public struct UpdateLanguage: Encodable, Sendable {
    public var locale: String?
    public var active: Bool?
    public var currencyId: Int?
    public var order: Int?

    public init(locale: String? = nil, active: Bool? = nil, currencyId: Int? = nil, order: Int? = nil) {
        self.locale = locale
        self.active = active
        self.currencyId = currencyId
        self.order = order
    }
}
