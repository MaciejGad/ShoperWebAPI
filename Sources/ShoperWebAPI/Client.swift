import Foundation

protocol ClientProtocol {
    func get(endpoint: Endpoint) async throws -> Data
    func post(endpoint: Endpoint, payload: any Encodable) async throws -> Data
    func put(endpoint: Endpoint, payload: any Encodable) async throws -> Data
    func delete(endpoint: Endpoint) async throws -> Data
    func decode<Model: Decodable>(data: Data) throws -> Model
}

@available(macOS 12.0, *)
public final class Client {
    public let config: Config
    public let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private var accessToken: Auth?
    
    public init(config: Config, session: URLSession = .shared) {
        self.config = config
        self.session = session
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
//        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        encoder.outputFormatting = .sortedKeys
    }
    
    private func fetchAccessToken() async throws {
        guard accessToken == nil else { return }
        let url = Endpoint.auth.url(config: config)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let basicAuth = "\(config.login):\(config.password)".data(using: .utf8)?.base64EncodedString() else {
            throw ShoperError.invalidCredentials
        }
        request.setValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ShoperError.invalidResponse(data, response)
        }
        accessToken = try decoder.decode(Auth.self, from: data)
    }
    
    func getAccessToken() async throws -> Auth {
        guard let accessToken = accessToken, accessToken.isValid() else {
            try await fetchAccessToken()
            guard let accessToken = accessToken else {
                throw ShoperError.invalidCredentials
            }
            return accessToken
        }
        return accessToken
    }
}

@available(macOS 12.0, *)
extension Client: ClientProtocol {
    
    func get(endpoint: Endpoint) async throws -> Data {
        try await request(endpoint, method: .get)
    }
    
    func post(endpoint: Endpoint, payload: any Encodable) async throws -> Data {
        try await request(endpoint, method: .post, payload: payload)
    }
    
    func put(endpoint: Endpoint, payload: any Encodable) async throws -> Data {
        try await request(endpoint, method: .put, payload: payload)
    }
    
    func delete(endpoint: Endpoint) async throws -> Data {
        try await request(endpoint, method: .delete)
    }
    
    func decode<Model: Decodable>(data: Data) throws -> Model {
        try decoder.decode(Model.self, from: data)
    }
    
    private func request(_ endpoint: Endpoint, method: Method, payload: (any Encodable)? = nil) async throws -> Data {
        let url = endpoint.url(config: config)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let payload = payload {
            request.httpBody = try encoder.encode(payload)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let accessToken = try await getAccessToken()
        request.setValue("Bearer \(accessToken.accessToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ShoperError.invalidResponse(data, response)
        }
        return data
    }

}
enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
