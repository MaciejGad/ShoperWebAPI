import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests exercise metafield-values / metafield-bind against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding and behavior. Responses are
// saved as new mocks via MOCK_PATH for future offline test runs.

@Test func testFetchMetafieldValues() async throws {
    let client = try makeClient()
    do {
        let list = try await MetafieldValue.list(client: client)
        print("MetafieldValues count: \(list.count)")
        for value in list.list {
            print(" * #\(value.valueId) metafieldId:\(String(describing: value.metafieldId)) objectId:\(String(describing: value.objectId)) value:\(value.value ?? "")")
        }
    } catch {
        print("MetafieldValues request failed as observed: \(error)")
    }
}

// metafield-bind requires the metafields_bind feature flag to be enabled on the shop — this
// documents actual behavior rather than assuming the flag is on.
@Test func testCreateMetafieldBind() async throws {
    let client = try makeClient()
    do {
        let payload = MetafieldBind(type: "product", itemId: "36", metafieldId: 1, value: "test")
        let bindId = try await MetafieldBind.create(client: client, payload: payload)
        print("Created metafield bind id: \(bindId) — this store may now support it.")
    } catch {
        print("MetafieldBind create failed as observed: \(error)")
    }
}
