import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import ShoperWebAPI

func mockFilePath(method: String, path: String, query: String?) throws -> String {
    let filename = try mockFilename(method: method, path: path, query: query)
    guard let filepath = Bundle.module.path(forResource: filename, ofType: "json") else {
        throw MockURLProtocol.MockError.cantFindMockFile(filename)
    }
    return filepath
}
