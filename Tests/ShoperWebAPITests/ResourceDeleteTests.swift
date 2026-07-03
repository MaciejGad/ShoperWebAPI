import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import ShoperWebAPI

/// A fake client that lets us simulate specific HTTP outcomes for `delete` without any network
/// access, so `Resource.delete`'s 404-means-false handling has stable offline coverage.
private struct FakeDeleteClient: ClientProtocol {
    enum Outcome {
        case success(Int)
        case notFound
    }

    let outcome: Outcome

    func get(endpoint: Endpoint, id: Int?, filters: Filters?, sort: ShoperWebAPI.SortOrder?, page: Int?, limit: Int?) async throws -> Data {
        fatalError("not used in this test")
    }

    func post(endpoint: Endpoint, payload: any Encodable) async throws -> Data {
        fatalError("not used in this test")
    }

    func put(endpoint: Endpoint, id: Int, payload: any Encodable) async throws -> Data {
        fatalError("not used in this test")
    }

    func delete(endpoint: Endpoint, id: Int) async throws -> Data {
        switch outcome {
        case .success(let value):
            return Data("\(value)".utf8)
        case .notFound:
            let url = URL(string: "https://example.com/webapi/rest/redirects/\(id)")!
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            throw ShoperError.invalidResponse(Data(), response)
        }
    }

    func decode<Model: Decodable>(data: Data) throws -> Model {
        try JSONDecoder().decode(Model.self, from: data)
    }
}

@Test func testResourceDeleteReturnsTrueOnSuccessBody() async throws {
    let client = FakeDeleteClient(outcome: .success(1))
    let deleted = try await Redirect.delete(client: client, id: 1)
    #expect(deleted == true)
}

@Test func testResourceDeleteReturnsFalseOnZeroBody() async throws {
    let client = FakeDeleteClient(outcome: .success(0))
    let deleted = try await Redirect.delete(client: client, id: 1)
    #expect(deleted == false)
}

@Test func testResourceDeleteReturnsFalseOn404() async throws {
    let client = FakeDeleteClient(outcome: .notFound)
    let deleted = try await Redirect.delete(client: client, id: 999)
    #expect(deleted == false)
}
