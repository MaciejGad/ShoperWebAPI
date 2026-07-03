import Foundation

/// Bitmask of places an additional field can appear.
public struct AdditionalFieldLocate: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let userContext = AdditionalFieldLocate(rawValue: 1)
    public static let userAccountContext = AdditionalFieldLocate(rawValue: 2)
    public static let userRegistrationForm = AdditionalFieldLocate(rawValue: 4)
    public static let orderForm = AdditionalFieldLocate(rawValue: 8)
    public static let anonymousOrderRequestingRegistration = AdditionalFieldLocate(rawValue: 16)
    public static let anonymousOrder = AdditionalFieldLocate(rawValue: 32)
    public static let loggedUserOrder = AdditionalFieldLocate(rawValue: 64)
    public static let contactForm = AdditionalFieldLocate(rawValue: 128)
}

extension AdditionalFieldLocate: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.init(rawValue: intValue)
            return
        }
        let stringValue = try container.decode(String.self)
        guard let intValue = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected Int-convertible value for AdditionalFieldLocate, got \"\(stringValue)\"")
        }
        self.init(rawValue: intValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
