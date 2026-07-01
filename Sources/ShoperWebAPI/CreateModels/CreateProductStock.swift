import Foundation

/// Payload for the `stock` object nested inside `ProductInsert`/`ProductUpdate`.
///
/// Note: unlike the standalone `/product-stocks` endpoint (`ProductStockInsert`), the nested
/// stock object in `ProductInsert` marks `active`, `code`, `default`, `ean`, `extended` and
/// `weight_type` as read-only. They are intentionally omitted from this payload.
public struct CreateProductStock: Encodable, Sendable {
    public var additionalCodes: AdditionalCodes?
    public var availabilityId: Int?
    public var calculationUnitId: Int?
    public var calculationUnitRatio: Decimal?
    public var deliveryId: Int?
    public var gfxId: Int?
    public var historicalLowestPrice: Decimal?
    public var package: Decimal?
    public var price: Decimal?
    public var priceSpecial: Decimal?
    public var priceWholesale: Decimal?
    public var sold: Decimal?
    public var soldRelative: Decimal?
    public var specialHistoricalLowestPrice: Decimal?
    public var stock: Decimal?
    public var stockRelative: Decimal?
    public var warehouses: [String: String]?
    public var warnLevel: Decimal?
    public var weight: Decimal?
    public var wholesaleHistoricalLowestPrice: Decimal?

    public struct AdditionalCodes: Encodable, Sendable {
        public var bloz12: Int?
        public var bloz7: Int?
        public var code39: Int?
        public var gtu: String?
        public var isbn: String?
        public var kgo: String?
        public var producer: String?
        public var warehouse: String?

        public init(
            bloz12: Int? = nil,
            bloz7: Int? = nil,
            code39: Int? = nil,
            gtu: String? = nil,
            isbn: String? = nil,
            kgo: String? = nil,
            producer: String? = nil,
            warehouse: String? = nil
        ) {
            self.bloz12 = bloz12
            self.bloz7 = bloz7
            self.code39 = code39
            self.gtu = gtu
            self.isbn = isbn
            self.kgo = kgo
            self.producer = producer
            self.warehouse = warehouse
        }

        public init(copying additionalCodes: Stock.AdditionalCodes) {
            self.bloz12 = additionalCodes.bloz12
            self.bloz7 = additionalCodes.bloz7
            self.code39 = additionalCodes.code39
            self.gtu = additionalCodes.gtu
            self.isbn = additionalCodes.isbn
            self.kgo = additionalCodes.kgo
            self.producer = additionalCodes.producer
            self.warehouse = additionalCodes.warehouse
        }
    }

    public init(
        additionalCodes: AdditionalCodes? = nil,
        availabilityId: Int? = nil,
        calculationUnitId: Int? = nil,
        calculationUnitRatio: Decimal? = nil,
        deliveryId: Int? = nil,
        gfxId: Int? = nil,
        historicalLowestPrice: Decimal? = nil,
        package: Decimal? = nil,
        price: Decimal? = nil,
        priceSpecial: Decimal? = nil,
        priceWholesale: Decimal? = nil,
        sold: Decimal? = nil,
        soldRelative: Decimal? = nil,
        specialHistoricalLowestPrice: Decimal? = nil,
        stock: Decimal? = nil,
        stockRelative: Decimal? = nil,
        warehouses: [String: String]? = nil,
        warnLevel: Decimal? = nil,
        weight: Decimal? = nil,
        wholesaleHistoricalLowestPrice: Decimal? = nil
    ) {
        self.additionalCodes = additionalCodes
        self.availabilityId = availabilityId
        self.calculationUnitId = calculationUnitId
        self.calculationUnitRatio = calculationUnitRatio
        self.deliveryId = deliveryId
        self.gfxId = gfxId
        self.historicalLowestPrice = historicalLowestPrice
        self.package = package
        self.price = price
        self.priceSpecial = priceSpecial
        self.priceWholesale = priceWholesale
        self.sold = sold
        self.soldRelative = soldRelative
        self.specialHistoricalLowestPrice = specialHistoricalLowestPrice
        self.stock = stock
        self.stockRelative = stockRelative
        self.warehouses = warehouses
        self.warnLevel = warnLevel
        self.weight = weight
        self.wholesaleHistoricalLowestPrice = wholesaleHistoricalLowestPrice
    }

    /// Copies only the fields writable in the nested ProductInsert stock object.
    /// Skips read-only fields: active, calculatedAvailabilityId, code, default, ean,
    /// extended, productId, stockId, weightType.
    public init(copying stock: Stock) {
        self.additionalCodes = stock.additionalCodes.map(AdditionalCodes.init(copying:))
        self.availabilityId = stock.availabilityId
        self.calculationUnitId = stock.calculationUnitId
        self.calculationUnitRatio = stock.calculationUnitRatio
        self.deliveryId = stock.deliveryId
        self.gfxId = stock.gfxId
        self.historicalLowestPrice = stock.historicalLowestPrice
        self.package = stock.package
        self.price = stock.price
        self.priceSpecial = stock.priceSpecial
        self.priceWholesale = stock.priceWholesale
        self.sold = stock.sold
        self.specialHistoricalLowestPrice = stock.specialHistoricalLowestPrice
        self.stock = stock.stock
        // Not copied: Stock.warehouses is [String: [String: Double]] (per-warehouse detail),
        // while the API expects [String: String] (warehouse id -> quantity). The shapes don't
        // match closely enough to convert safely without a confirmed real-world example.
        self.warnLevel = stock.warnLevel
        self.weight = stock.weight
        self.wholesaleHistoricalLowestPrice = stock.wholesaleHistoricalLowestPrice
    }
}
