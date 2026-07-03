import Foundation

public enum AdditionalFieldType: Equatable, Sendable {
    case text
    case checkbox
    case select
    case file
    case hidden
    case description
    /// A value returned by the API that doesn't match any documented case.
    case unknown(Int)

    public init(rawValue: Int) {
        switch rawValue {
        case 1: self = .text
        case 2: self = .checkbox
        case 3: self = .select
        case 4: self = .file
        case 5: self = .hidden
        case 6: self = .description
        default: self = .unknown(rawValue)
        }
    }

    public var rawValue: Int {
        switch self {
        case .text: return 1
        case .checkbox: return 2
        case .select: return 3
        case .file: return 4
        case .hidden: return 5
        case .description: return 6
        case .unknown(let value): return value
        }
    }
}

extension AdditionalFieldType: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.init(rawValue: intValue)
            return
        }
        let stringValue = try container.decode(String.self)
        guard let intValue = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected Int-convertible value for AdditionalFieldType, got \"\(stringValue)\"")
        }
        self.init(rawValue: intValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
