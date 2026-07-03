import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests exercise product-files against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding and the create payload.
// Responses are saved as new mocks via MOCK_PATH for future offline test runs.

@Test func testFetchProductFiles() async throws {
    let client = try makeClient()
    let list = try await ProductFile.list(client: client)
    print("ProductFiles count: \(list.count)")
    for file in list.list {
        print(" * #\(file.fileId) translationId:\(file.translationId) fileName:\(file.fileName) type:\(String(describing: file.type)) active:\(String(describing: file.active))")
    }
}

// This test only validates payload encoding — it does NOT hit the live API, since creating a
// product file is a mutating action that would leave a real file on the store.
@Test func testCreateProductFilePayloadEncoding() throws {
    let content = Data("hello world".utf8)
    let payload = CreateProductFile.file(content: content, translationId: 36, fileName: "test-file.txt", description: "Test upload")

    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(payload)
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])

    #expect(json["translation_id"] as? Int == 36)
    #expect(json["file_name"] as? String == "test-file.txt")
    #expect(json["content"] as? String == content.base64EncodedString())
    #expect(json["description"] as? String == "Test upload")
}

// This test store is a sandbox, so it's safe to mutate: it uploads a real file to verify the
// full create -> get round trip against the live API.
@Test func testCreateProductFileRoundTrip() async throws {
    let client = try makeClient()
    // file_name must be unique within the shop, so include a timestamp to allow re-running.
    let uniqueName = "shoperwebapi-test-file-\(Int(Date().timeIntervalSince1970)).txt"
    let content = Data("hello from ShoperWebAPI test suite".utf8)
    let payload = CreateProductFile.file(
        content: content,
        translationId: 36,
        fileName: uniqueName,
        description: "Uploaded by ShoperWebAPI P5b round-trip test",
        active: true,
        type: 0
    )
    let fileId = try await ProductFile.create(client: client, payload: payload)
    print("Created file id: \(fileId)")
    #expect(fileId > 0)

    let fetched = try await ProductFile.get(client: client, id: fileId)
    print(fetched)
    #expect(fetched.fileId == fileId)
    #expect(fetched.translationId == 36)
    // The API stores the given filename in `name`; `fileName` is a server-generated unique name.
    // Match by prefix/suffix rather than exact equality: when re-run offline against a frozen
    // mock, `uniqueName` (built from the current timestamp) won't equal the value baked into the
    // mock from whichever run originally recorded it.
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-file-") == true)
    #expect(fetched.name?.hasSuffix(".txt") == true)
    #expect(!fetched.fileName.isEmpty)
    #expect(fetched.description == "Uploaded by ShoperWebAPI P5b round-trip test")
    #expect(fetched.addDate != nil)
}
