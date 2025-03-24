import Foundation

enum Identifier {
    case id(Int)
    case none
}

protocol Model: Codable {
    var id: Identifier { get }
    static var endpoint: Endpoint { get }
    
    func with(id: Identifier) -> Self
}

protocol Resource {
    associatedtype M: Model
    static func list(client: ClientProtocol) async throws -> [M]
    static func create(client: ClientProtocol, model: M) async throws -> M
    static func read(client: ClientProtocol, id: Int) async throws -> Model?
}

extension Resource {
    static func list(client: ClientProtocol) async throws -> [M] {
        let data = try await client.get(endpoint: M.endpoint)
        return try client.decode(data: data)
    }
}
