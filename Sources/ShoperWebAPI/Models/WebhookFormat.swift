import Foundation

public enum WebhookFormat: Equatable, Sendable {
    case json
    case xml
    /// A value returned by the API that doesn't match any documented case.
    case unknown(Int)

    public init(rawValue: Int) {
        switch rawValue {
        case 0: self = .json
        case 1: self = .xml
        default: self = .unknown(rawValue)
        }
    }

    public var rawValue: Int {
        switch self {
        case .json: return 0
        case .xml: return 1
        case .unknown(let value): return value
        }
    }
}

extension WebhookFormat: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.init(rawValue: intValue)
            return
        }
        let stringValue = try container.decode(String.self)
        guard let intValue = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected Int-convertible value for WebhookFormat, got \"\(stringValue)\"")
        }
        self.init(rawValue: intValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
