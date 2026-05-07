import Foundation

public struct PickupPointData: Codable {
    public let point: String?
    public let supplier: String?
    public let supplierName: String?
    public let description: String?
    public let street: String?
    public let houseNumber: String?
    public let city: String?
    public let postalCode: String?
    public let province: String?
    public let countryCode: String?
    public let servicesCod: Bool?
    public let latitude: String?
    public let longitude: String?
    public let openingHours: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.point = try container.decodeIfPresent(String.self, forKey: .point)
        self.supplier = try container.decodeIfPresent(String.self, forKey: .supplier)
        self.supplierName = try container.decodeIfPresent(String.self, forKey: .supplierName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.street = try container.decodeIfPresent(String.self, forKey: .street)
        self.houseNumber = try container.decodeIfPresent(String.self, forKey: .houseNumber)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        self.province = try container.decodeIfPresent(String.self, forKey: .province)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.servicesCod = try container.decodeBoolIfPresent(forKey: .servicesCod)
        self.latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        self.openingHours = try container.decodeIfPresent(String.self, forKey: .openingHours)
    }
}
