import Foundation

public struct PromotionCode: Decodable, Sendable {
    public let codeId: Int
    public let code: String
    public let name: String
    public let active: Bool?
    public let discountType: Int?
    public let discount: Decimal?
    public let global: Bool?
    public let minAmount: Decimal?
    public let maxAmount: Decimal?
    public let minQuantity: Int?
    public let maxQuantity: Int?
    public let usageCount: Int?
    public let usageLimit: Int?
    public let peruserLimit: Int?
    public let timeFrom: String?
    public let timeTo: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.codeId = try container.decodeInt(forKey: .codeId)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.discountType = try container.decodeIntIfPresent(forKey: .discountType)
        self.discount = try container.decodeDecimalIfPresent(forKey: .discount)
        self.global = try container.decodeBoolIfPresent(forKey: .global)
        self.minAmount = try container.decodeDecimalIfPresent(forKey: .minAmount)
        self.maxAmount = try container.decodeDecimalIfPresent(forKey: .maxAmount)
        self.minQuantity = try container.decodeIntIfPresent(forKey: .minQuantity)
        self.maxQuantity = try container.decodeIntIfPresent(forKey: .maxQuantity)
        self.usageCount = try container.decodeIntIfPresent(forKey: .usageCount)
        self.usageLimit = try container.decodeIntIfPresent(forKey: .usageLimit)
        self.peruserLimit = try container.decodeIntIfPresent(forKey: .peruserLimit)
        self.timeFrom = try container.decodeIfPresent(String.self, forKey: .timeFrom)
        self.timeTo = try container.decodeIfPresent(String.self, forKey: .timeTo)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case codeId
        case code
        case name
        case active
        case discountType
        case discount
        case global
        case minAmount
        case maxAmount
        case minQuantity
        case maxQuantity
        case usageCount
        case usageLimit
        case peruserLimit
        case timeFrom
        case timeTo
    }
}

extension PromotionCode: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreatePromotionCode
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(codeId) }
    public static var endpoint: Endpoint { .promotionCodes }
}
