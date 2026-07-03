import Foundation

public struct CreateAdditionalField: Encodable, Sendable {
    public var type: AdditionalFieldType
    public var locate: AdditionalFieldLocate
    public var translations: [String: Translation]
    public var active: Bool?
    public var checked: Bool?
    public var order: Int?
    public var req: Bool?

    public struct Translation: Encodable, Sendable {
        public var name: String
        public var description: String?
        /// Options for `select`-type fields.
        public var options: [String]?

        public init(name: String, description: String? = nil, options: [String]? = nil) {
            self.name = name
            self.description = description
            self.options = options
        }
    }

    public init(
        type: AdditionalFieldType,
        locate: AdditionalFieldLocate,
        translations: [String: Translation],
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
