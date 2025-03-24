import Foundation

enum ShoperError: Error {
    case invalidCredentials
    case invalidResponse(Data, URLResponse)
}
