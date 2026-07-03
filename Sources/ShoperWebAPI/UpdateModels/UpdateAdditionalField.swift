import Foundation

public struct UpdateAdditionalField: Encodable, Sendable {
    public var type: AdditionalFieldType?
    public var locate: AdditionalFieldLocate?
    public var translations: [String: CreateAdditionalField.Translation]?
    public var active: Bool?
    public var checked: Bool?
    public var order: Int?
    public var req: Bool?

    public init(
        type: AdditionalFieldType? = nil,
        locate: AdditionalFieldLocate? = nil,
        translations: [String: CreateAdditionalField.Translation]? = nil,
        active: Bool? = nil,
        checked: Bool? = nil,
        order: Int? = nil,
        req: Bool? = nil
    ) {
        self.type = type
        self.locate = locate
        self.translations = translations
        self.active = active
        self.checked = checked
        self.order = order
        self.req = req
    }
}
