import Foundation

public struct GeolocationRegion: Decodable, Sendable {
    public let regionId: Int
    public let countryId: Int?
    public let isocode: String?
    public let name: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regionId = try container.decodeInt(forKey: .regionId)
        self.countryId = try container.decodeIntIfPresent(forKey: .countryId)
        self.isocode = try container.decodeIfPresent(String.self, forKey: .isocode)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case regionId
        case countryId
        case isocode
        case name
    }
}

extension GeolocationRegion: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(regionId) }
    public static var endpoint: Endpoint { .geolocationRegions }
}
