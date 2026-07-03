import Foundation

public struct UserAddress: Decodable, Sendable {
    public let addressBookId: Int
    public let userId: Int
    public let firstname: String
    public let lastname: String
    public let street1: String
    public let street2: String?
    public let city: String
    public let zipCode: String
    public let phone: String
    public let country: String?
    public let countryCode: String?
    public let state: String?
    public let companyName: String?
    public let addressName: String?
    public let pesel: String?
    public let taxIdentificationNumber: String?
    public let `default`: Bool?
    public let shippingDefault: Bool?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.addressBookId = try container.decodeInt(forKey: .addressBookId)
        self.userId = try container.decodeInt(forKey: .userId)
        self.firstname = try container.decode(String.self, forKey: .firstname)
        self.lastname = try container.decode(String.self, forKey: .lastname)
        self.street1 = try container.decode(String.self, forKey: .street1)
        self.street2 = try container.decodeIfPresent(String.self, forKey: .street2)
        self.city = try container.decode(String.self, forKey: .city)
        self.zipCode = try container.decode(String.self, forKey: .zipCode)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        self.addressName = try container.decodeIfPresent(String.self, forKey: .addressName)
        self.pesel = try container.decodeIfPresent(String.self, forKey: .pesel)
        self.taxIdentificationNumber = try container.decodeIfPresent(String.self, forKey: .taxIdentificationNumber)
        self.default = try container.decodeBoolIfPresent(forKey: .default)
        self.shippingDefault = try container.decodeBoolIfPresent(forKey: .shippingDefault)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case addressBookId
        case userId
        case firstname
        case lastname
        case street1
        case street2
        case city
        case zipCode
        case phone
        case country
        case countryCode
        case state
        case companyName
        case addressName
        case pesel
        case taxIdentificationNumber
        case `default`
        case shippingDefault
    }
}

extension UserAddress: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateUserAddress
    public typealias UpdatePayload = UpdateUserAddress

    public var id: Identifier { .id(addressBookId) }
    public static var endpoint: Endpoint { .userAddresses }
}
