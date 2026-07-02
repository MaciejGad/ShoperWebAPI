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
