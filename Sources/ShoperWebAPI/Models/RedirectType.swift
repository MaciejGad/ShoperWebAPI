import Foundation

public enum RedirectType: Equatable, Sendable {
    case own
    case product
    case categoryProduct
    case producer
    case infopage
    case news
    case categoryNews
    /// A value returned by the API that doesn't match any documented case.
    case unknown(Int)

    public init(rawValue: Int) {
        switch rawValue {
        case 0: self = .own
        case 1: self = .product
        case 2: self = .categoryProduct
        case 3: self = .producer
        case 4: self = .infopage
        case 5: self = .news
        case 6: self = .categoryNews
        default: self = .unknown(rawValue)
        }
    }

    public var rawValue: Int {
        switch self {
        case .own: return 0
        case .product: return 1
        case .categoryProduct: return 2
        case .producer: return 3
        case .infopage: return 4
        case .news: return 5
        case .categoryNews: return 6
        case .unknown(let value): return value
        }
    }
}

extension RedirectType: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.init(rawValue: intValue)
            return
        }
        let stringValue = try container.decode(String.self)
        guard let intValue = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected Int-convertible value for RedirectType, got \"\(stringValue)\"")
        }
        self.init(rawValue: intValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
