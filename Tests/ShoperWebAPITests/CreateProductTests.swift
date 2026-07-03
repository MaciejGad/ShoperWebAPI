import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

private func encodeToJSON(_ value: some Encodable) throws -> [String: Any] {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(value)
    let object = try JSONSerialization.jsonObject(with: data)
    return try #require(object as? [String: Any])
}

// MARK: - Minimal payload encoding

@Test func testCreateProductEncodesMinimalPayload() throws {
    let payload = CreateProduct(
        categoryId: 19,
        code: "TEST-001",
        pkwiu: "",
        stock: CreateProductStock(price: 99.99, stock: 10),
        translations: ["pl_PL": CreateProductTranslation(name: "Test product")]
    )
    let json = try encodeToJSON(payload)

    #expect(json["category_id"] as? Int == 19)
    #expect(json["code"] as? String == "TEST-001")
    #expect(json["pkwiu"] as? String == "")
    #expect(json["stock"] != nil)
    #expect(json["translations"] != nil)

    // Optional fields not set should be omitted entirely
    #expect(json["tax_id"] == nil)
    #expect(json["unit_id"] == nil)
    #expect(json["attributes"] == nil)
    #expect(json["safety_information"] == nil)
}

@Test func testCreateProductStockOmitsReadOnlyFields() throws {
    let stock = CreateProductStock(price: 19.90, stock: 8)
    let json = try encodeToJSON(stock)

    #expect(json["price"] != nil)
    #expect(json["stock"] != nil)
    // These are read-only in the nested ProductInsert.stock schema and must never appear,
    // since CreateProductStock intentionally doesn't expose them.
    #expect(json["active"] == nil)
    #expect(json["code"] == nil)
    #expect(json["default"] == nil)
    #expect(json["ean"] == nil)
    #expect(json["extended"] == nil)
    #expect(json["weight_type"] == nil)
}

// MARK: - Feeds exludes wire key (historical typo preserved by API)

@Test func testCreateProductFeedsExludesKey() throws {
    let payload = CreateProduct(
        categoryId: 1,
        code: "X",
        pkwiu: "",
        stock: CreateProductStock(),
        translations: [:],
        feedsExludes: [1, 2, 3]
    )
    let json = try encodeToJSON(payload)
    #expect(json["feeds_exludes"] as? [Int] == [1, 2, 3])
}

// MARK: - CreateProduct(copying:) doesn't leak read-only fields

@Test func testCreateProductCopyingDoesNotEncodeReadOnlyFields() async throws {
    let client = try makeClient()
    let product = try await Product.get(client: client, id: 36)
    let payload = CreateProduct(copying: product)
    let json = try encodeToJSON(payload)

    // Read-only / not part of ProductInsert
    #expect(json["product_id"] == nil)
    #expect(json["stock_id"] == nil)
    #expect(json["translation_id"] == nil)
    #expect(json["add_date"] == nil)
    #expect(json["edit_date"] == nil)
    #expect(json["main_image"] == nil)
    #expect(json["children"] == nil)
    #expect(json["group_id"] == nil)
    #expect(json["calculated_availability_id"] == nil)
    #expect(json["permalink"] == nil)

    let stock = try #require(json["stock"] as? [String: Any])
    #expect(stock["stock_id"] == nil)
    #expect(stock["product_id"] == nil)
    #expect(stock["calculated_availability_id"] == nil)
    #expect(stock["code"] == nil)
    #expect(stock["active"] == nil)

    let translations = try #require(json["translations"] as? [String: Any])
    let plTranslation = try #require(translations["pl_PL"] as? [String: Any])
    #expect(plTranslation["translation_id"] == nil)
    #expect(plTranslation["product_id"] == nil)
    #expect(plTranslation["permalink"] == nil)
    #expect(plTranslation["lang_id"] == nil)

    // Basic sanity: the copied product data made it across
    #expect(json["category_id"] as? Int == product.categoryId)
    #expect(json["code"] as? String == product.code)
}

// MARK: - Attribute flattening

@Test func testFlattenAttributesForProductInsert() async throws {
    let client = try makeClient()
    let product = try await Product.get(client: client, id: 36)
    let flat = product.attributes.flattenedForProductInsert()
    // Nested groups become a single flat attributeId -> value map
    for group in product.attributes.values.values {
        for (attributeId, value) in group.values {
            #expect(flat[attributeId] == value)
        }
    }
}

// MARK: - UpdateProduct mirrors CreateProduct's field set (all optional)

@Test func testUpdateProductEncodesOnlySetFields() throws {
    let payload = UpdateProduct(
        code: "NEW-CODE",
        stock: CreateProductStock(price: 50, stock: 3),
        translations: ["pl_PL": CreateProductTranslation(name: "Updated name")],
        collections: [2, 3],
        tags: [10]
    )
    let json = try encodeToJSON(payload)

    #expect(json["code"] as? String == "NEW-CODE")
    #expect(json["stock"] != nil)
    #expect(json["translations"] != nil)
    #expect(json["collections"] as? [Int] == [2, 3])
    #expect(json["tags"] as? [Int] == [10])

    // Everything not explicitly set should be omitted, matching partial-update semantics.
    #expect(json["category_id"] == nil)
    #expect(json["pkwiu"] == nil)
    #expect(json["tax_id"] == nil)
    #expect(json["safety_information"] == nil)
}

@Test func testUpdateProductStockOmitsReadOnlyFields() throws {
    // UpdateProduct.stock reuses CreateProductStock, so it inherits the same read-only exclusions
    // as product creation (active/code/default/ean/extended/weight_type aren't writable here).
    let payload = UpdateProduct(stock: CreateProductStock(price: 10, stock: 1))
    let json = try encodeToJSON(payload)
    let stock = try #require(json["stock"] as? [String: Any])
    #expect(stock["active"] == nil)
    #expect(stock["code"] == nil)
    #expect(stock["weight_type"] == nil)
}

// MARK: - Product.create decodes a raw numeric response

@Test func testProductCreateDecodesPlainNumberResponse() async throws {
    let client = try makeClient()
    let payload = CreateProduct(
        categoryId: 19,
        code: "TEST-CREATE-001",
        pkwiu: "",
        stock: CreateProductStock(price: 10, stock: 1),
        translations: ["pl_PL": CreateProductTranslation(name: "Test")]
    )
    let newProductId = try await Product.create(client: client, payload: payload)
    #expect(newProductId == 93)
}
