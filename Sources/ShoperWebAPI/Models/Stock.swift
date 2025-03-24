import Foundation

struct Stock: Codable {
    let stockId: Int
    let productId: Int
    let extended: Bool
    let price: Decimal
    let active: Bool
    let `default`: Bool
    let stock: Decimal
    let warehouses: [String: [String: Double]]?
    let warnLevel: Decimal?
    let sold: Decimal
    let code: String
    let ean: String
    let weight: Decimal
    let weightType: Int
    let availabilityId: Int?
    let calculatedAvailabilityId: Int
    let deliveryId: Int
    let gfxId: Int?
    let package: Decimal
    let priceWholesale: Decimal
    let priceSpecial: Decimal
    let calculationUnitId: Int?
    let calculationUnitRatio: Decimal
    let historicalLowestPrice: Decimal
    let wholesaleHistoricalLowestPrice: Decimal
    let specialHistoricalLowestPrice: Decimal
    let additionalCodes: AdditionalCodes?

    struct AdditionalCodes: Codable {
        let bloz12: Int
        let bloz7: Int
        let code39: Int
        let gtu: String
        let isbn: String
        let kgo: String
        let producer: String
        let warehouse: String
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Stock.AdditionalCodes.CodingKeys> = try decoder.container(keyedBy: Stock.AdditionalCodes.CodingKeys.self)
            self.bloz12 = try container.decodeInt(forKey: Stock.AdditionalCodes.CodingKeys.bloz12)
            self.bloz7 = try container.decodeInt(forKey: Stock.AdditionalCodes.CodingKeys.bloz7)
            self.code39 = try container.decodeInt(forKey: Stock.AdditionalCodes.CodingKeys.code39)
            self.gtu = try container.decode(String.self, forKey: Stock.AdditionalCodes.CodingKeys.gtu)
            self.isbn = try container.decode(String.self, forKey: Stock.AdditionalCodes.CodingKeys.isbn)
            self.kgo = try container.decode(String.self, forKey: Stock.AdditionalCodes.CodingKeys.kgo)
            self.producer = try container.decode(String.self, forKey: Stock.AdditionalCodes.CodingKeys.producer)
            self.warehouse = try container.decode(String.self, forKey: Stock.AdditionalCodes.CodingKeys.warehouse)
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stockId = try container.decodeInt(forKey: .stockId)
        self.productId = try container.decodeInt(forKey: .productId)
        self.extended = try container.decodeBool(forKey: .extended)
        self.price = try container.decodeDecimal(forKey: .price)
        self.active = try container.decodeBool(forKey: .active)
        self.default = try container.decodeBool(forKey: .default)
        self.stock = try container.decodeDecimal(forKey: .stock)
        self.warehouses = try container.decodeIfPresent([String : [String : Double]].self, forKey: .warehouses)
        self.warnLevel = try container.decodeDecimalIfPresent(forKey: .warnLevel)
        self.sold = try container.decodeDecimal(forKey: .sold)
        self.code = try container.decode(String.self, forKey: .code)
        self.ean = try container.decode(String.self, forKey: .ean)
        self.weight = try container.decodeDecimal(forKey: .weight)
        self.weightType = try container.decodeInt(forKey: .weightType)
        self.availabilityId = try container.decodeIntIfPresent(forKey: .availabilityId)
        self.calculatedAvailabilityId = try container.decodeInt(forKey: .calculatedAvailabilityId)
        self.deliveryId = try container.decodeInt(forKey: .deliveryId)
        self.gfxId = try container.decodeIntIfPresent(forKey: .gfxId)
        self.package = try container.decodeDecimal(forKey: .package)
        self.priceWholesale = try container.decodeDecimal(forKey: .priceWholesale)
        self.priceSpecial = try container.decodeDecimal(forKey: .priceSpecial)
        self.calculationUnitId = try container.decodeIntIfPresent(forKey: .calculationUnitId)
        self.calculationUnitRatio = try container.decodeDecimal(forKey: .calculationUnitRatio)
        self.historicalLowestPrice = try container.decodeDecimal(forKey: .historicalLowestPrice)
        self.wholesaleHistoricalLowestPrice = try container.decodeDecimal(forKey: .wholesaleHistoricalLowestPrice)
        self.specialHistoricalLowestPrice = try container.decodeDecimal(forKey: .specialHistoricalLowestPrice)
        self.additionalCodes = try container.decodeIfPresent(Stock.AdditionalCodes.self, forKey: .additionalCodes)
    }
}
