import Foundation

public struct CreateProduct: Encodable, Sendable {
    public var categoryId: Int
    public var code: String
    public var pkwiu: String
    public var stock: CreateProductStock
    public var translations: [String: CreateProductTranslation]

    public var taxId: Int?
    public var unitId: Int?
    public var producerId: Int?
    public var currencyId: Int?
    public var gaugeId: Int?
    public var ean: String?
    public var otherPrice: Decimal?
    public var dimensionW: Decimal?
    public var dimensionH: Decimal?
    public var dimensionL: Decimal?
    public var volWeight: Decimal?
    public var unitPriceCalculation: Bool?
    public var isProductOfDay: Bool?

    public var attributes: [String: String]?
    public var categories: [Int]?
    public var related: [Int]?
    public var feedsExludes: [Int]?
    public var tagId: Int?
    public var tags: [Int]?
    public var safetyInformation: ProductSafetyInformationPayload?

    public init(
        categoryId: Int,
        code: String,
        pkwiu: String,
        stock: CreateProductStock,
        translations: [String: CreateProductTranslation],
        taxId: Int? = nil,
        unitId: Int? = nil,
        producerId: Int? = nil,
        currencyId: Int? = nil,
        gaugeId: Int? = nil,
        ean: String? = nil,
        otherPrice: Decimal? = nil,
        dimensionW: Decimal? = nil,
        dimensionH: Decimal? = nil,
        dimensionL: Decimal? = nil,
        volWeight: Decimal? = nil,
        unitPriceCalculation: Bool? = nil,
        isProductOfDay: Bool? = nil,
        attributes: [String: String]? = nil,
        categories: [Int]? = nil,
        related: [Int]? = nil,
        feedsExludes: [Int]? = nil,
        tagId: Int? = nil,
        tags: [Int]? = nil,
        safetyInformation: ProductSafetyInformationPayload? = nil
    ) {
        self.categoryId = categoryId
        self.code = code
        self.pkwiu = pkwiu
        self.stock = stock
        self.translations = translations
        self.taxId = taxId
        self.unitId = unitId
        self.producerId = producerId
        self.currencyId = currencyId
        self.gaugeId = gaugeId
        self.ean = ean
        self.otherPrice = otherPrice
        self.dimensionW = dimensionW
        self.dimensionH = dimensionH
        self.dimensionL = dimensionL
        self.volWeight = volWeight
        self.unitPriceCalculation = unitPriceCalculation
        self.isProductOfDay = isProductOfDay
        self.attributes = attributes
        self.categories = categories
        self.related = related
        self.feedsExludes = feedsExludes
        self.tagId = tagId
        self.tags = tags
        self.safetyInformation = safetyInformation
    }

    /// Builds a create payload by copying only the fields writable by `ProductInsert` from an
    /// existing product. Read-only fields (productId, stockId, translationId, addDate, editDate,
    /// mainImage, children, groupId, calculatedAvailabilityId, permalink, ...) are never copied
    /// because the target types don't expose them.
    ///
    /// Not copied: `collections`, `options`, `tagId`, `tags` — the source `Product` model does not
    /// currently decode these fields.
    public init(copying product: Product) {
        self.categoryId = product.categoryId
        self.code = product.code
        self.pkwiu = product.pkwiu
        self.stock = CreateProductStock(copying: product.stock)
        self.translations = product.translations.mapValues(CreateProductTranslation.init(copying:))
        self.taxId = product.taxId
        self.unitId = product.unitId
        self.producerId = product.producerId
        self.currencyId = product.currencyId
        self.gaugeId = product.gaugeId
        self.ean = product.ean
        self.otherPrice = product.otherPrice
        self.dimensionW = product.dimensionW
        self.dimensionH = product.dimensionH
        self.dimensionL = product.dimensionL
        self.volWeight = product.volWeight
        self.unitPriceCalculation = product.unitPriceCalculation
        self.isProductOfDay = product.isProductOfDay
        self.attributes = product.attributes.flattenedForProductInsert()
        self.categories = product.categories
        self.related = product.related
        self.feedsExludes = product.feedsExludes
        self.safetyInformation = ProductSafetyInformationPayload(copying: product.safetyInformation)
    }
}
