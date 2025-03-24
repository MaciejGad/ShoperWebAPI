import Foundation

struct Product: Codable {
    let productId: Int?
    let type: Int
    let producerId: Int?
    let groupId: Int?
    let taxId: Int
    let categoryId: Int
    let unitId: Int
    let addDate: String
    let editDate: String
    let otherPrice: Decimal
    let promoPrice: Decimal?
    let code: String
    let dimensionW: Decimal
    let dimensionH: Decimal
    let dimensionL: Decimal
    let ean: String
    let pkwiu: String
    let isProductOfDay: Bool
    let loyaltyScore: Int?
    let loyaltyPrice: Int?
    let inLoyalty: Bool
    let bestseller: Bool
    let newproduct: Bool
    let volWeight: Decimal
    let gaugeId: Int?
    let currencyId: Int?
    let additionalBloz12: Int?
    let additionalBloz7: Int?
    let additionalCode39: Int?
    let additionalGtu: String?
    let additionalIsbn: String?
    let additionalKgo: String?
    let additionalProducer: String?
    let additionalWarehouse: String?
    let related: [Int]
    let options: [Int]
    let mainImage: ProductImage?
    let stock: Stock
    let translations: [String: Translation]
    let attributes: [String: [String: String]]
    let categories: [Int]
    let specialOffer: SpecialOffer?
    let unitPriceCalculation: Bool
    let children: ProductChild?
    let feedsExludes: [Int]?
    let safetyInformation: SafetyInformation
    
    init(from decoder: any Decoder) throws {
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
        self.attributes = try container.decode([String : [String : String]].self, forKey: .attributes)
        self.categories = try container.decode([Int].self, forKey: .categories)
        self.specialOffer = try container.decodeIfPresent(SpecialOffer.self, forKey: .specialOffer)
        self.unitPriceCalculation = try container.decodeBool(forKey: .unitPriceCalculation)
        self.children = try container.decodeIfPresent(ProductChild.self, forKey: .children)
        self.feedsExludes = try container.decodeIfPresent([Int].self, forKey: .feedsExludes)
        self.safetyInformation = try container.decode(SafetyInformation.self, forKey: .safetyInformation)
    }
}

extension Product: Resource {
    var id: Identifier {
        return productId.map { Identifier.id($0) } ?? .none
    }
    
    static var endpoint: Endpoint {
        .products
    }    
}
