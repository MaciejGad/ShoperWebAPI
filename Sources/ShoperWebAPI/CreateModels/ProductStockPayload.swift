import Foundation

/// Payload for the standalone `/product-stocks` endpoint (`ProductStockInsert`/`ProductStockUpdate`).
///
/// Unlike `CreateProductStock` (used for the `stock` object nested inside `ProductInsert`), this
/// type exposes `active`, `code`, `default`, `ean` and `weight_type` as writable — the OpenAPI
/// schema marks them read-only only in the nested product-create context, not here.
///
/// The insert and update schemas are structurally identical, so a single type serves both.
public struct ProductStockPayload: Encodable, Sendable {
    public var productId: Int?
    public var active: Bool?
    public var code: String?
    public var `default`: Bool?
    public var ean: String?
    public var additionalCodes: CreateProductStock.AdditionalCodes?
    public var availabilityId: Int?
    public var calculationUnitId: Int?
    public var calculationUnitRatio: Decimal?
    public var deliveryId: Int?
    public var gfxId: Int?
    public var historicalLowestPrice: Decimal?
    public var options: [Option]?
    public var package: Decimal?
    public var price: Decimal?
    public var priceBuying: Decimal?
    public var priceSpecial: Decimal?
    public var priceType: Int?
    public var priceTypeSpecial: Int?
    public var priceTypeWholesale: Int?
    public var priceWholesale: Decimal?
    public var sold: Decimal?
    public var specialHistoricalLowestPrice: Decimal?
    public var stock: Decimal?
    public var warnLevel: Decimal?
    public var weight: Decimal?
    public var weightType: Int?
    public var wholesaleHistoricalLowestPrice: Decimal?

    public struct Option: Encodable, Sendable {
        public var optionId: Int?
        public var valueId: Int?

        public init(optionId: Int? = nil, valueId: Int? = nil) {
            self.optionId = optionId
            self.valueId = valueId
        }
    }

    public init(
        productId: Int? = nil,
        active: Bool? = nil,
        code: String? = nil,
        default: Bool? = nil,
        ean: String? = nil,
        additionalCodes: CreateProductStock.AdditionalCodes? = nil,
        availabilityId: Int? = nil,
        calculationUnitId: Int? = nil,
        calculationUnitRatio: Decimal? = nil,
        deliveryId: Int? = nil,
        gfxId: Int? = nil,
        historicalLowestPrice: Decimal? = nil,
        options: [Option]? = nil,
        package: Decimal? = nil,
        price: Decimal? = nil,
        priceBuying: Decimal? = nil,
        priceSpecial: Decimal? = nil,
        priceType: Int? = nil,
        priceTypeSpecial: Int? = nil,
        priceTypeWholesale: Int? = nil,
        priceWholesale: Decimal? = nil,
        sold: Decimal? = nil,
        specialHistoricalLowestPrice: Decimal? = nil,
        stock: Decimal? = nil,
        warnLevel: Decimal? = nil,
        weight: Decimal? = nil,
        weightType: Int? = nil,
        wholesaleHistoricalLowestPrice: Decimal? = nil
    ) {
        self.productId = productId
        self.active = active
        self.code = code
        self.default = `default`
        self.ean = ean
        self.additionalCodes = additionalCodes
        self.availabilityId = availabilityId
        self.calculationUnitId = calculationUnitId
        self.calculationUnitRatio = calculationUnitRatio
        self.deliveryId = deliveryId
        self.gfxId = gfxId
        self.historicalLowestPrice = historicalLowestPrice
        self.options = options
        self.package = package
        self.price = price
        self.priceBuying = priceBuying
        self.priceSpecial = priceSpecial
        self.priceType = priceType
        self.priceTypeSpecial = priceTypeSpecial
        self.priceTypeWholesale = priceTypeWholesale
        self.priceWholesale = priceWholesale
        self.sold = sold
        self.specialHistoricalLowestPrice = specialHistoricalLowestPrice
        self.stock = stock
        self.warnLevel = warnLevel
        self.weight = weight
        self.weightType = weightType
        self.wholesaleHistoricalLowestPrice = wholesaleHistoricalLowestPrice
    }
}
