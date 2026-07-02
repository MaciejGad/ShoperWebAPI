import Foundation

public struct Product: Codable, Sendable {
    public let productId: Int?
    public let type: Int
    public let producerId: Int?
    public let groupId: Int?
    public let taxId: Int
    public let categoryId: Int
    public let unitId: Int
    public let addDate: String
    public let editDate: String
    public let otherPrice: Decimal
    public let promoPrice: Decimal?
    public let code: String
    public let dimensionW: Decimal
    public let dimensionH: Decimal
    public let dimensionL: Decimal
    public let ean: String
    public let pkwiu: String
    public let isProductOfDay: Bool
    public let loyaltyScore: Int?
    public let loyaltyPrice: Int?
    public let inLoyalty: Bool
    public let bestseller: Bool
    public let newproduct: Bool
    public let volWeight: Decimal
    public let gaugeId: Int?
    public let currencyId: Int?
    public let additionalBloz12: Int?
    public let additionalBloz7: Int?
    public let additionalCode39: Int?
    public let additionalGtu: String?
    public let additionalIsbn: String?
    public let additionalKgo: String?
    public let additionalProducer: String?
    public let additionalWarehouse: String?
    public let related: [Int]
    public let options: [Int]
    public let mainImage: ProductImage?
    public let stock: Stock
    public let translations: [String: Translation]
    public let attributes: Attributes
    public let categories: [Int]
    public let specialOffer: SpecialOffer?
    public let unitPriceCalculation: Bool
    public let children: ProductChild?
    public let feedsExludes: [Int]?
    public let safetyInformation: SafetyInformation
    public let collections: [Int]?
    public let tags: [Int]?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decodeInt(forKey: .productId)
        self.type = try container.decodeInt(forKey: .type)
        self.producerId = try container.decodeIntIfPresent(forKey: .producerId)
        self.groupId = try container.decodeIntIfPresent(forKey: .groupId)
        self.taxId = try container.decodeInt(forKey: .taxId)
        self.categoryId = try container.decodeInt(forKey: .categoryId)
        self.unitId = try container.decodeInt(forKey: .unitId)
        self.addDate = try container.decode(String.self, forKey: .addDate)
        self.editDate = try container.decode(String.self, forKey: .editDate)
        self.otherPrice = try container.decodeDecimal(forKey: .otherPrice)
        self.promoPrice = try container.decodeDecimalIfPresent(forKey: .promoPrice)
        self.code = try container.decode(String.self, forKey: .code)
        self.dimensionW = try container.decodeDecimal(forKey: .dimensionW)
        self.dimensionH = try container.decodeDecimal(forKey: .dimensionH)
        self.dimensionL = try container.decodeDecimal(forKey: .dimensionL)
        self.ean = try container.decode(String.self, forKey: .ean)
        self.pkwiu = try container.decode(String.self, forKey: .pkwiu)
        self.isProductOfDay = try container.decodeBool(forKey: .isProductOfDay)
        self.loyaltyScore = try container.decodeIntIfPresent(forKey: .loyaltyScore)
        self.loyaltyPrice = try container.decodeIntIfPresent(forKey: .loyaltyPrice)
        self.inLoyalty = try container.decodeBool(forKey: .inLoyalty)
        self.bestseller = try container.decodeBool(forKey: .bestseller)
        self.newproduct = try container.decodeBool(forKey: .newproduct)
        self.volWeight = try container.decodeDecimal(forKey: .volWeight)
        self.gaugeId = try container.decodeIntIfPresent(forKey: .gaugeId)
        self.currencyId = try container.decodeIntIfPresent(forKey: .currencyId)
        self.additionalBloz12 = try container.decodeIntIfPresent(forKey: .additionalBloz12)
        self.additionalBloz7 = try container.decodeIntIfPresent(forKey: .additionalBloz7)
        self.additionalCode39 = try container.decodeIntIfPresent(forKey: .additionalCode39)
        self.additionalGtu = try container.decodeIfPresent(String.self, forKey: .additionalGtu)
        self.additionalIsbn = try container.decodeIfPresent(String.self, forKey: .additionalIsbn)
        self.additionalKgo = try container.decodeIfPresent(String.self, forKey: .additionalKgo)
        self.additionalProducer = try container.decodeIfPresent(String.self, forKey: .additionalProducer)
        self.additionalWarehouse = try container.decodeIfPresent(String.self, forKey: .additionalWarehouse)
        self.related = try container.decode([Int].self, forKey: .related)
        self.options = try container.decode([Int].self, forKey: .options)
        self.mainImage = try container.decodeIfPresent(ProductImage.self, forKey: .mainImage)
        self.stock = try container.decode(Stock.self, forKey: .stock)
        self.translations = try container.decode([String : Translation].self, forKey: .translations)
        self.attributes = try container.decode(Attributes.self, forKey: .attributes)
        self.categories = try container.decode([Int].self, forKey: .categories)
        self.specialOffer = try container.decodeIfPresent(SpecialOffer.self, forKey: .specialOffer)
        self.unitPriceCalculation = try container.decodeBool(forKey: .unitPriceCalculation)
        self.children = try container.decodeIfPresent(ProductChild.self, forKey: .children)
        self.feedsExludes = try container.decodeIfPresent([Int].self, forKey: .feedsExludes)
        self.safetyInformation = try container.decode(SafetyInformation.self, forKey: .safetyInformation)
        self.collections = try container.decodeIntArrayIfPresent(forKey: .collections)
        self.tags = try container.decodeIntArrayIfPresent(forKey: .tags)
    }
}

extension Product: Resource {
    public typealias Key = ProductFilterKey
    public typealias CreatePayload = CreateProduct
    public typealias UpdatePayload = UpdateProduct
    public typealias Sort = ProductSortKey
    
    public var id: Identifier {
        return productId.map { Identifier.id($0) } ?? .none
    }
    
    public static var endpoint: Endpoint {
        .products
    }
}
