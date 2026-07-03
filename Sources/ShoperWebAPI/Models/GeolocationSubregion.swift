import Foundation

public struct GeolocationSubregion: Decodable, Sendable {
    public let subregionId: Int
    public let regionId: Int?
    public let countryId: Int?
    public let name: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subregionId = try container.decodeInt(forKey: .subregionId)
        self.regionId = try container.decodeIntIfPresent(forKey: .regionId)
        self.countryId = try container.decodeIntIfPresent(forKey: .countryId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case subregionId
        case regionId
        case countryId
        case name
    }
}

extension GeolocationSubregion: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(subregionId) }
    public static var endpoint: Endpoint { .geolocationSubregions }
}
