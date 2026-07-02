import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// This test fetches a real product from a live Shoper store (see SHOPER_DOMAIN/USERNAME/PASSWORD
// env vars) to validate that `collections` and `tags` decode correctly. The response is saved as
// a new mock via MOCK_PATH for future offline test runs.
@Test func testFetchProductDecodesCollectionsAndTags() async throws {
    let client = try makeClient()
    let product = try await Product.get(client: client, id: 36)
    print("collections: \(product.collections ?? [])")
    print("tags: \(product.tags ?? [])")

    // Both fields must decode without throwing even when present in the real API response;
    // absence (nil) is also acceptable if the product has none assigned.
    if let collections = product.collections {
        #expect(collections.allSatisfy { $0 > 0 })
    }
    if let tags = product.tags {
        #expect(tags.allSatisfy { $0 > 0 })
    }
}
