import Foundation

public struct OrderAddress: Codable {
    public let addressId: Int?
    public let orderId: Int?
    public let type: Int?
    public let firstname: String?
    public let lastname: String?
    public let company: String?
    public let pesel: String?
    public let city: String?
    public let postcode: String?
    public let street1: String?
    public let street2: String?
    public let state: String?
    public let country: String?
    public let phone: String?
    public let countryCode: String?
    public let taxIdentificationNumber: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.addressId = try container.decodeIntIfPresent(forKey: .addressId)
        self.orderId = try container.decodeIntIfPresent(forKey: .orderId)
        self.type = try container.decodeIntIfPresent(forKey: .type)
        self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        self.company = try container.decodeIfPresent(String.self, forKey: .company)
        self.pesel = try container.decodeIfPresent(String.self, forKey: .pesel)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.postcode = try container.decodeIfPresent(String.self, forKey: .postcode)
        self.street1 = try container.decodeIfPresent(String.self, forKey: .street1)
        self.street2 = try container.decodeIfPresent(String.self, forKey: .street2)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.taxIdentificationNumber = try container.decodeIfPresent(String.self, forKey: .taxIdentificationNumber)
    }
}
