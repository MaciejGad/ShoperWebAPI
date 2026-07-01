import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// MARK: - ShoperAttribute

@Test func testFetchAttributes() async throws {
    let client = try makeClient()
    let list = try await ShoperAttribute.list(client: client)
    #expect(list.count == 18)
    #expect(list.list.count == 10)

    let attribute18 = try #require(list.list.first(where: { $0.attributeId == 18 }))
    #expect(attribute18.name == "Wzór")
    #expect(attribute18.type == 2)
    #expect(attribute18.active == true)
    #expect(!attribute18.options.isEmpty)

    let attribute10 = try #require(list.list.first(where: { $0.attributeId == 10 }))
    #expect(attribute10.name == "Skład materiału")
    #expect(attribute10.type == 2)
    #expect(attribute10.options.count == 9)
    #expect(attribute10.options[0] == "55% len, 45% wiskoza")
    #expect(attribute10.options[1] == "95% poliester, 5% elastan")
    #expect(attribute10.options[2] == "100% wiskoza")

    let attribute19 = try #require(list.list.first(where: { $0.attributeId == 19 }))
    #expect(attribute19.active == true)
    #expect(attribute19.name == "Zapięcie")
}

@Test func testAttributeListAll() async throws {
    let client = try makeClient()
    let all = try await ShoperAttribute.listAll(client: client)
    #expect(all.count == 18)
}

// MARK: - ShoperCategory

@Test func testFetchCategories() async throws {
    let client = try makeClient()
    let list = try await ShoperCategory.list(client: client)
    #expect(list.count == 22)
    #expect(list.list.count == 10)

    let okulary = try #require(list.list.first(where: { $0.categoryId == 19 }))
    #expect(okulary.name(locale: "pl_PL") == "Akcesoria")
    #expect(okulary.name(locale: "en_GB") == nil)

    let sukienki = try #require(list.list.first(where: { $0.categoryId == 24 }))
    #expect(sukienki.name() == "Sukienki letnie")
}

// MARK: - CategoryTreeNode

@Test func testCategoryTreeParentMap() async throws {
    let client = try makeClient()
    let nodes = try await CategoryTreeNode.listAll(client: client)
    #expect(nodes.count == 2)
    print(nodes)
    let root1 = try #require(nodes.first(where: { $0.id == 21}))
    #expect(root1.children.count == 7)
    print("Root 1 children: \(root1.children.map { $0 })")
    let child = try #require(root1.children.first(where: { $0.id == 16 }))
    try #require(child.children.count == 3)
    #expect(child.children[0].id == 24)

    let parentMap = CategoryTreeNode.buildParentMap(nodes: nodes)
    print(parentMap)
    #expect(parentMap[24] == 16)
    #expect(parentMap[30] == 21)
    #expect(parentMap[26] == 25)
}

@Test func testShoperCategoryFetchParentMap() async throws {
    let client = try makeClient()
    let parentMap = try await ShoperCategory.fetchParentMap(client: client)
    #expect(parentMap[24] == 16)
    #expect(parentMap[30] == 21)
    #expect(parentMap[26] == 25)
}

@Test func testShoperCategoryListPairedWithParentMap() async throws {
    let client = try makeClient()
    let categories = try await ShoperCategory.list(client: client).list
    let parentMap = try await ShoperCategory.fetchParentMap(client: client)

    // Category 24 ("Sukienki letnie") is a known child of tree node 16 in the fixture data.
    let sukienki = try #require(categories.first(where: { $0.categoryId == 24 }))
    #expect(parentMap[sukienki.categoryId] == 16)

    // Category 16 itself is a top-level child of root node 21, so it has a parent too,
    // even though it isn't present in the /categories page-1 mock.
    #expect(parentMap[16] == 21)
}

// MARK: - Config with access token

@Test func testConfigWithAccessToken() async throws {
    guard let mockEnvPath = Bundle.module.url(forResource: "mock_env", withExtension: "json") else {
        throw ConfigError.missingConfig
    }
    let data = try Data(contentsOf: mockEnvPath)
    let environment = try JSONDecoder().decode(Environment.self, from: data)
    // Using a ready access token should bypass POST /auth entirely
    let config = Config(shopURL: environment.shopURL, accessToken: "4d462094833722563fcc225b0966539e368fd4de", verbose: true, storeToFile: true)
    let client = Client(config: config, session: environment.session)
    // If token is not used, this would try to POST /auth with empty credentials and fail
    let list = try await ShoperAttribute.list(client: client)
    #expect(list.count == 18)
}
