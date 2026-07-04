import Foundation

public struct CreatePaymentChannel: Encodable, Sendable {
    public var channelKey: String
    public var applicationChannelId: String?
    public var currencies: [String]?
    public var type: String?
    public var translations: [String: UpdatePaymentChannel.Translation]?

    public init(
        channelKey: String,
        applicationChannelId: String? = nil,
        currencies: [String]? = nil,
        type: String? = nil,
        translations: [String: UpdatePaymentChannel.Translation]? = nil
    ) {
        self.channelKey = channelKey
        self.applicationChannelId = applicationChannelId
        self.currencies = currencies
        self.type = type
        self.translations = translations
    }
}
