import Foundation

public struct GeolocationCountry: Decodable, Sendable {
    public let countryId: Int
    public let isocode: String?
    public let active: Bool?
    /// Are post codes supported for this country?
    public let codes: Bool?
    /// Are regions supported for this country?
    public let regions: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countryId = try container.decodeInt(forKey: .countryId)
        self.isocode = try container.decodeIfPresent(String.self, forKey: .isocode)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.codes = try container.decodeBoolIfPresent(forKey: .codes)
        self.regions = try container.decodeBoolIfPresent(forKey: .regions)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case countryId
        case isocode
        case active
        case codes
        case regions
    }
}

extension GeolocationCountry: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(countryId) }
    public static var endpoint: Endpoint { .geolocationCountries }
}
