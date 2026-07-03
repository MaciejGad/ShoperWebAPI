import Foundation

/// Payload for `PUT /products/{id}` (`ProductUpdate`). Structurally identical to `CreateProduct`
/// except every field is optional, since an update only needs to send the fields being changed.
/// Reuses `CreateProductStock`/`CreateProductTranslation`/`ProductSafetyInformationPayload` —
/// the nested `stock`/`translations`/`safety_information` shapes in `ProductUpdate` are the same
/// as in `ProductInsert` (including the same read-only exclusions on the nested stock object).
public struct UpdateProduct: Encodable, Sendable {
    public var categoryId: Int?
    public var code: String?
    public var pkwiu: String?
    public var stock: CreateProductStock?
    public var translations: [String: CreateProductTranslation]?

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
    public var collections: [Int]?
    public var related: [Int]?
    public var feedsExludes: [Int]?
    public var tagId: Int?
    public var tags: [Int]?
    public var safetyInformation: ProductSafetyInformationPayload?

    public init(
        categoryId: Int? = nil,
        code: String? = nil,
        pkwiu: String? = nil,
        stock: CreateProductStock? = nil,
        translations: [String: CreateProductTranslation]? = nil,
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
        collections: [Int]? = nil,
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
        self.collections = collections
        self.related = related
        self.feedsExludes = feedsExludes
        self.tagId = tagId
        self.tags = tags
        self.safetyInformation = safetyInformation
    }
}
