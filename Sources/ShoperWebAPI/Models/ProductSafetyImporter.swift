import Foundation

public struct ProductSafetyImporter: Decodable, Sendable {
    public let gpsrImporterId: Int
    public let internalName: String
    public let name: String
    public let countryCode: String
    public let city: String
    public let street1: String
    public let street2: String?
    public let postcode: String
    public let phone: String?
    public let email: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gpsrImporterId = try container.decodeInt(forKey: .gpsrImporterId)
        self.internalName = try container.decode(String.self, forKey: .internalName)
        self.name = try container.decode(String.self, forKey: .name)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.city = try container.decode(String.self, forKey: .city)
        self.street1 = try container.decode(String.self, forKey: .street1)
        self.street2 = try container.decodeIfPresent(String.self, forKey: .street2)
        self.postcode = try container.decode(String.self, forKey: .postcode)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case gpsrImporterId
        case internalName
        case name
        case countryCode
        case city
        case street1
        case street2
        case postcode
        case phone
        case email
    }
}

extension ProductSafetyImporter: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(gpsrImporterId) }
    public static var endpoint: Endpoint { .productSafetyImporters }
}
