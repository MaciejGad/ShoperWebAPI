import Foundation

public struct Zone: Decodable, Sendable {
    public let zoneId: Int
    public let name: String
    /// Zone mode: 1 - countries, 2 - countries with regions, 3 - post codes.
    public let mode: Int
    public let countryId: Int?
    public let countries: [Int]?
    public let regions: [Int]?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.zoneId = try container.decodeInt(forKey: .zoneId)
        self.name = try container.decode(String.self, forKey: .name)
        self.mode = try container.decodeInt(forKey: .mode)
        self.countryId = try container.decodeIntIfPresent(forKey: .countryId)
        self.countries = try container.decodeIntArrayIfPresent(forKey: .countries)
        self.regions = try container.decodeIntArrayIfPresent(forKey: .regions)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case zoneId
        case name
        case mode
        case countryId
        case countries
        case regions
    }
}

extension Zone: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(zoneId) }
    public static var endpoint: Endpoint { .zones }
}
