import Foundation

public struct UpdateUserGroup: Encodable, Sendable {
    public var name: String?
    public var discount: Decimal?
    /// Pricing level, 1-3.
    public var priceLevel: Int?
    public var autoAdd: Bool?

    public init(name: String? = nil, discount: Decimal? = nil, priceLevel: Int? = nil, autoAdd: Bool? = nil) {
        self.name = name
        self.discount = discount
        self.priceLevel = priceLevel
        self.autoAdd = autoAdd
    }
}
