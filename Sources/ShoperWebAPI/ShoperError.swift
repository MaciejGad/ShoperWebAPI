import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum ShoperError: Error {
    case invalidCredentials
    case invalidURL
    case invalidResponse(Data, URLResponse)
}
