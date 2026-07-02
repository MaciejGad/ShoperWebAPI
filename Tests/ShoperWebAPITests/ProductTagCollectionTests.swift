import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch product-tags and collections from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchProductTags() async throws {
    let client = try makeClient()
    let list = try await ProductTag.list(client: client)
    print("ProductTags count: \(list.count)")
    for tag in list.list {
        print(" * #\(tag.tagId) \(tag.name) langId:\(tag.langId)")
    }
}

@Test func testFetchCollections() async throws {
    let client = try makeClient()
    let list = try await Collection.list(client: client)
    print("Collections count: \(list.count)")
    for collection in list.list {
        print(" * #\(collection.collectionId) \(collection.name() ?? "") sortType:\(String(describing: collection.sortType))")
    }
}
