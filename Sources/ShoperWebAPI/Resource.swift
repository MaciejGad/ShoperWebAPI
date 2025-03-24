import Foundation

protocol Resource: Decodable {
    var id: Identifier { get }
    static var endpoint: Endpoint { get }
    
    static func list(client: ClientProtocol) async throws -> ResourceList<Self>
//    static func create(client: ClientProtocol, model: M) async throws -> M
//    static func read(client: ClientProtocol, id: Int) async throws -> Model?
}

extension Resource {
    static func list(client: ClientProtocol) async throws -> ResourceList<Self> {
        let data = try await client.get(endpoint: Self.endpoint, id: nil)
        return try client.decode(data: data)
    }
}
