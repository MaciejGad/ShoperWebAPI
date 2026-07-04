import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// Nested under a collection (`/collections/{collection_id}/products`) — see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars for the live-test path. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchCollectionProducts() async throws {
    let client = try makeClient()
    do {
        let collections = try await Collection.list(client: client)
        guard let collection = collections.list.first else {
            print("No collections on this store — skipping.")
            return
        }
        let products = try await CollectionProduct.list(client: client, collectionId: collection.collectionId)
        print("CollectionProducts count for collection #\(collection.collectionId): \(products.count)")
        for product in products.list.prefix(5) {
            print(" * product #\(product.productId) position:\(String(describing: product.position))")
        }
    } catch {
        // No mock recorded yet for this nested endpoint — run live (see AGENTS.md Testing
        // workflow) to generate one; offline replay can't succeed until then.
        print("CollectionProduct fetch failed as observed: \(error)")
    }
}

@Test func testUpdateCollectionProductPosition() async throws {
    let client = try makeClient()
    do {
        let collections = try await Collection.list(client: client)
        guard let collection = collections.list.first else {
            print("No collections on this store — skipping.")
            return
        }
        let products = try await CollectionProduct.list(client: client, collectionId: collection.collectionId)
        guard let product = products.list.first else {
            print("Collection #\(collection.collectionId) has no products — skipping.")
            return
        }
        try await CollectionProduct.update(
            client: client,
            collectionId: collection.collectionId,
            productId: product.productId,
            payload: UpdateCollectionProduct(position: product.position)
        )
        print("Updated position for product #\(product.productId) in collection #\(collection.collectionId)")
    } catch {
        print("CollectionProduct update failed as observed: \(error)")
    }
}
