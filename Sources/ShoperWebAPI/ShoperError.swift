import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum ShoperError: Error {
    case invalidCredentials
    case invalidURL
    case invalidResponse(Data, URLResponse)
}
