import Foundation

public struct CreatePromotionCode: Encodable, Sendable {
    public var name: String
    public var code: String
    public var discountType: Int
    public var active: Bool?
    public var discount: Decimal?
    public var global: Bool?
    public var minAmount: Decimal?
    public var maxAmount: Decimal?
    public var minQuantity: Int?
    public var maxQuantity: Int?
    public var usageLimit: Int?
    public var peruserLimit: Int?
    public var timeFrom: String?
    public var timeTo: String?

    public init(
        name: String,
        code: String,
        discountType: Int,
        active: Bool? = nil,
        discount: Decimal? = nil,
        global: Bool? = nil,
        minAmount: Decimal? = nil,
        maxAmount: Decimal? = nil,
        minQuantity: Int? = nil,
        maxQuantity: Int? = nil,
        usageLimit: Int? = nil,
        peruserLimit: Int? = nil,
        timeFrom: String? = nil,
        timeTo: String? = nil
    ) {
        self.name = name
        self.code = code
        self.discountType = discountType
        self.active = active
        self.discount = discount
        self.global = global
        self.minAmount = minAmount
        self.maxAmount = maxAmount
        self.minQuantity = minQuantity
        self.maxQuantity = maxQuantity
        self.usageLimit = usageLimit
        self.peruserLimit = peruserLimit
        self.timeFrom = timeFrom
        self.timeTo = timeTo
    }
}
