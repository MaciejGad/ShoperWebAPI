import Foundation

public struct UpdateUserAddress: Encodable, Sendable {
    public var firstname: String?
    public var lastname: String?
    public var street1: String?
    public var city: String?
    public var zipCode: String?
    public var phone: String?
    public var userId: Int?
    public var addressName: String?
    public var companyName: String?
    public var country: String?
    public var countryCode: String?
    public var street2: String?
    public var state: String?
    public var pesel: String?
    public var taxIdentificationNumber: String?
    public var `default`: Bool?
    public var shippingDefault: Bool?

    public init(
        firstname: String? = nil,
        lastname: String? = nil,
        street1: String? = nil,
        city: String? = nil,
        zipCode: String? = nil,
        phone: String? = nil,
        userId: Int? = nil,
        addressName: String? = nil,
        companyName: String? = nil,
        country: String? = nil,
        countryCode: String? = nil,
        street2: String? = nil,
        state: String? = nil,
        pesel: String? = nil,
        taxIdentificationNumber: String? = nil,
        default: Bool? = nil,
        shippingDefault: Bool? = nil
    ) {
        self.firstname = firstname
        self.lastname = lastname
        self.street1 = street1
        self.city = city
        self.zipCode = zipCode
        self.phone = phone
        self.userId = userId
        self.addressName = addressName
        self.companyName = companyName
        self.country = country
        self.countryCode = countryCode
        self.street2 = street2
        self.state = state
        self.pesel = pesel
        self.taxIdentificationNumber = taxIdentificationNumber
        self.default = `default`
        self.shippingDefault = shippingDefault
    }
}
