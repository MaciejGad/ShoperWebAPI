import Foundation

public struct OrderAdditionalField: Codable, Sendable {
    public let fieldId: Int?
    public let type: Int?
    public let locate: Int?
    public let req: Int?
    public let active: Int?
    public let order: Int?
    public let fieldValue: String?
    public let value: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fieldId = try container.decodeIntIfPresent(forKey: .fieldId)
        self.type = try container.decodeIntIfPresent(forKey: .type)
        self.locate = try container.decodeIntIfPresent(forKey: .locate)
        self.req = try container.decodeIntIfPresent(forKey: .req)
        self.active = try container.decodeIntIfPresent(forKey: .active)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.fieldValue = try container.decodeIfPresent(String.self, forKey: .fieldValue)
        self.value = try container.decodeIfPresent(String.self, forKey: .value)
    }
}
