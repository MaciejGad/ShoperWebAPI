import Foundation

public struct CreateAdditionalFieldOption: Encodable, Sendable {
    public var fieldId: Int
    public var translations: [String: Translation]

    public struct Translation: Encodable, Sendable {
        public var value: String

        public init(value: String) {
            self.value = value
        }
    }

    public init(fieldId: Int, translations: [String: Translation]) {
        self.fieldId = fieldId
        self.translations = translations
    }
}
