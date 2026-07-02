import Foundation

public struct ProductSafetyResponsible: Decodable, Sendable {
    public let gpsrResponsibleId: Int
    public let internalName: String
    public let name: String
    public let countryCode: String
    public let city: String
    public let street1: String
    public let street2: String?
    public let postcode: String
    public let phone: String?
    public let email: String?
    public let contactFormUrl: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gpsrResponsibleId = try container.decodeInt(forKey: .gpsrResponsibleId)
        self.internalName = try container.decode(String.self, forKey: .internalName)
        self.name = try container.decode(String.self, forKey: .name)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.city = try container.decode(String.self, forKey: .city)
        self.street1 = try container.decode(String.self, forKey: .street1)
        self.street2 = try container.decodeIfPresent(String.self, forKey: .street2)
        self.postcode = try container.decode(String.self, forKey: .postcode)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.contactFormUrl = try container.decodeIfPresent(String.self, forKey: .contactFormUrl)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case gpsrResponsibleId
        case internalName
        case name
        case countryCode
        case city
        case street1
        case street2
        case postcode
        case phone
        case email
        case contactFormUrl
    }
}

extension ProductSafetyResponsible: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(gpsrResponsibleId) }
    public static var endpoint: Endpoint { .productSafetyResponsibles }
}
