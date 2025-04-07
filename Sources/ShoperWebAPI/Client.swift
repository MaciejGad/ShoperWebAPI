import Foundation

public protocol ClientProtocol {
    func get(endpoint: Endpoint, id: Int?, filters: Filters?, page: Int?) async throws -> Data
    func post(endpoint: Endpoint, payload: any Encodable) async throws -> Data
    func put(endpoint: Endpoint, id: Int, payload: any Encodable) async throws -> Data
    func delete(endpoint: Endpoint, id: Int) async throws -> Data
    func decode<Model: Decodable>(data: Data) throws -> Model
}

@available(macOS 12.0, *)
public final class Client {
    public let config: Config
    public let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private var filterEncoder: JSONEncoder
    private var accessToken: Auth?
    
    public init(config: Config, session: URLSession = .shared) {
        self.config = config
        self.session = session
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        encoder.outputFormatting = .sortedKeys
        filterEncoder = JSONEncoder()
    }
    
    private func fetchAccessToken() async throws {
        guard accessToken == nil else { return }
        let url = try Endpoint.auth.url(config: config)
        if config.verbose {
            print("Url: \(url)")
        }
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
        if config.storeToFile {
            saveToFile(data: data, method: .post, url: url)
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
    
    public func get(endpoint: Endpoint, id: Int?, filters: Filters?, page: Int?) async throws -> Data {
        try await request(endpoint, id: id, method: .get, filters: filters, page: page)
    }
    
    public func post(endpoint: Endpoint, payload: any Encodable) async throws -> Data {
        try await request(endpoint, id: nil, method: .post, payload: payload)
    }
    
    public func put(endpoint: Endpoint, id: Int, payload: any Encodable) async throws -> Data {
        try await request(endpoint, id: id, method: .put, payload: payload)
    }
    
    public func delete(endpoint: Endpoint, id: Int) async throws -> Data {
        try await request(endpoint, id: id, method: .delete)
    }
    
    public func decode<Model: Decodable>(data: Data) throws -> Model {
        try decoder.decode(Model.self, from: data)
    }
    
    private func request(_ endpoint: Endpoint, id: Int?, method: Method, payload: (any Encodable)? = nil, filters: Filters? = nil, page: Int? = nil) async throws -> Data {
        let filtersString: String?
        if let filters {
            let filtersData = try filterEncoder.encode(filters)
            filtersString = String(decoding: filtersData, as: UTF8.self)
        } else {
            filtersString = nil
        }
        let url = try endpoint.url(config: config, id: id, filters: filtersString, page: page)
        if config.verbose {
            print("Url: \(url)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let payload {
            request.httpBody = try encoder.encode(payload)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let accessToken = try await getAccessToken()
        request.setValue("Bearer \(accessToken.accessToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode > 199, httpResponse.statusCode < 300 else {
            throw ShoperError.invalidResponse(data, response)
        }
        if config.verbose {
            print(String(data: data, encoding: .utf8) ?? "")
        }
        if config.storeToFile {
            saveToFile(data: data, method: method, url: url)
        }
        return data
    }
    
    private func saveToFile(data: Data, method: Method, url: URL) {
        do {
            let fileName = try mockFilename(method: method.rawValue, path: url.path, query: url.query)
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("mocks")
                .appendingPathComponent("\(fileName).json")
            try data.write(to: fileURL)
            if config.verbose {
                print("Saved response to: \(fileURL.path)")
            }
        } catch {
            print("Error saving file: \(error)")
        }
    }
    
}
