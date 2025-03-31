import Foundation

func mockFilePath(method: String, path: String, query: String?) throws -> String {
    let filename = method + path.replacingOccurrences(of: "/", with: "_")
    guard let filepath = Bundle.module.path(forResource: filename, ofType: "json") else {
        throw MockURLProtocol.MockError.cantFindMockFile(filename)
    }
    return filepath
}
