import Foundation

public struct Currency: Decodable, Sendable {
    public let currencyId: Int?
    public let name: String
    public let active: Bool?
    public let `default`: Bool?
    public let order: Int?
    public let rate: Decimal?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.name = try container.decode(String.self, forKey: .name)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.default = try container.decodeBoolIfPresent(forKey: .default)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.rate = try container.decodeDecimalIfPresent(forKey: .rate)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case currencyId
        case name
        case active
        case `default`
        case order
        case rate
    }
}

extension Currency: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { currencyId.map { .id($0) } ?? .none }
    public static var endpoint: Endpoint { .currencies }
}
