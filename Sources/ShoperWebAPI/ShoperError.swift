import Foundation

enum ShoperError: Error {
    case invalidCredentials
    case invalidURL
    case invalidResponse(Data, URLResponse)
}
