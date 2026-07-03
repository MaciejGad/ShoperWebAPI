import Foundation

public struct UpdateAdditionalFieldOption: Encodable, Sendable {
    public var fieldId: Int?
    public var translations: [String: CreateAdditionalFieldOption.Translation]?

    public init(fieldId: Int? = nil, translations: [String: CreateAdditionalFieldOption.Translation]? = nil) {
        self.fieldId = fieldId
        self.translations = translations
    }
}
