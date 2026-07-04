import Foundation

public struct UpdatePaymentChannel: Encodable, Sendable {
    public struct Translation: Encodable, Sendable {
        public var name: String?
        public var description: String?
        public var additionalInfoLabel: String?
        public var imageUrl: String?
        public var active: Bool?

        public init(
            name: String? = nil,
            description: String? = nil,
            additionalInfoLabel: String? = nil,
            imageUrl: String? = nil,
            active: Bool? = nil
        ) {
            self.name = name
            self.description = description
            self.additionalInfoLabel = additionalInfoLabel
            self.imageUrl = imageUrl
            self.active = active
        }
    }

    public var applicationChannelId: String?
    public var currencies: [String]?
    public var type: String?
    public var translations: [String: Translation]?

    public init(
        applicationChannelId: String? = nil,
        currencies: [String]? = nil,
        type: String? = nil,
        translations: [String: Translation]? = nil
    ) {
        self.applicationChannelId = applicationChannelId
        self.currencies = currencies
        self.type = type
        self.translations = translations
    }
}
