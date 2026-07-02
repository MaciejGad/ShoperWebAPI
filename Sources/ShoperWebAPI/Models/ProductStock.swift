import Foundation

/// A product stock entry from the standalone `/product-stocks` endpoint.
///
/// Note: unlike the `stock` object nested inside `Product`/`ProductInsert`, this resource
/// exposes `active`, `code`, `default`, `ean`, `extended` and `weight_type` as writable fields
/// (see `ProductStockPayload`). Multi-warehouse fields (`warehouses`) are intentionally not
/// modeled since this library targets shops without multi-warehouse enabled.
public struct ProductStock: Decodable, Sendable {
    public let stockId: Int
    public let productId: Int
    public let active: Bool
    public let `default`: Bool
    public let extended: Bool
    public let code: String
    public let ean: String
    public let price: Decimal
    public let priceBuying: Decimal?
    public let priceSpecial: Decimal
    public let priceWholesale: Decimal
    public let priceType: Int
    public let priceTypeSpecial: Int
    public let priceTypeWholesale: Int
    public let stock: Decimal
    public let sold: Decimal
    public let warnLevel: Decimal?
    public let weight: Decimal
    public let weightType: Int
    public let package: Decimal
    public let availabilityId: Int?
    public let calculatedAvailabilityId: Int?
    public let deliveryId: Int
    public let gfxId: Int?
    public let calculationUnitId: Int?
    public let calculationUnitRatio: Decimal
    public let historicalLowestPrice: Decimal
    public let wholesaleHistoricalLowestPrice: Decimal
    public let specialHistoricalLowestPrice: Decimal
    public let additionalCodes: Stock.AdditionalCodes?
    public let specialOffer: SpecialOffer?
    /// Legacy assoc map `{option_id: value_id}` as returned by the API.
    public let options: [String: Int]?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stockId = try container.decodeInt(forKey: .stockId)
        self.productId = try container.decodeInt(forKey: .productId)
        self.active = try container.decodeBool(forKey: .active)
        self.default = try container.decodeBool(forKey: .default)
        self.extended = try container.decodeBool(forKey: .extended)
        self.code = try container.decode(String.self, forKey: .code)
        self.ean = try container.decode(String.self, forKey: .ean)
        self.price = try container.decodeDecimal(forKey: .price)
        self.priceBuying = try container.decodeDecimalIfPresent(forKey: .priceBuying)
        self.priceSpecial = try container.decodeDecimal(forKey: .priceSpecial)
        self.priceWholesale = try container.decodeDecimal(forKey: .priceWholesale)
        self.priceType = try container.decodeInt(forKey: .priceType)
        self.priceTypeSpecial = try container.decodeInt(forKey: .priceTypeSpecial)
        self.priceTypeWholesale = try container.decodeInt(forKey: .priceTypeWholesale)
        self.stock = try container.decodeDecimal(forKey: .stock)
        self.sold = try container.decodeDecimal(forKey: .sold)
        self.warnLevel = try container.decodeDecimalIfPresent(forKey: .warnLevel)
        self.weight = try container.decodeDecimal(forKey: .weight)
        self.weightType = try container.decodeInt(forKey: .weightType)
        self.package = try container.decodeDecimal(forKey: .package)
        self.availabilityId = try container.decodeIntIfPresent(forKey: .availabilityId)
        self.calculatedAvailabilityId = try container.decodeIntIfPresent(forKey: .calculatedAvailabilityId)
        self.deliveryId = try container.decodeInt(forKey: .deliveryId)
        self.gfxId = try container.decodeIntIfPresent(forKey: .gfxId)
        self.calculationUnitId = try container.decodeIntIfPresent(forKey: .calculationUnitId)
        self.calculationUnitRatio = try container.decodeDecimal(forKey: .calculationUnitRatio)
        self.historicalLowestPrice = try container.decodeDecimal(forKey: .historicalLowestPrice)
        self.wholesaleHistoricalLowestPrice = try container.decodeDecimal(forKey: .wholesaleHistoricalLowestPrice)
        self.specialHistoricalLowestPrice = try container.decodeDecimal(forKey: .specialHistoricalLowestPrice)
        // The API returns [] (empty array) when there are no additional codes instead of null/omitting the field.
        self.additionalCodes = try? container.decode(Stock.AdditionalCodes.self, forKey: .additionalCodes)
        self.specialOffer = try? container.decode(SpecialOffer.self, forKey: .specialOffer)
        self.options = try? container.decode([String: Int].self, forKey: .options)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case stockId
        case productId
        case active
        case `default`
        case extended
        case code
        case ean
        case price
        case priceBuying
        case priceSpecial
        case priceWholesale
        case priceType
        case priceTypeSpecial
        case priceTypeWholesale
        case stock
        case sold
        case warnLevel
        case weight
        case weightType
        case package
        case availabilityId
        case calculatedAvailabilityId
        case deliveryId
        case gfxId
        case calculationUnitId
        case calculationUnitRatio
        case historicalLowestPrice
        case wholesaleHistoricalLowestPrice
        case specialHistoricalLowestPrice
        case additionalCodes
        case specialOffer
        case options
    }
}

// MARK: - Resource

extension ProductStock: Resource {
    public typealias Key = ProductStockFilterKey
    public typealias Sort = ProductStockSortKey
    public typealias CreatePayload = ProductStockPayload
    public typealias UpdatePayload = ProductStockPayload

    public var id: Identifier { .id(stockId) }
    public static var endpoint: Endpoint { .productStocks }
}
