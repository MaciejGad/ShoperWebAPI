import Foundation

protocol Resource: Decodable {
    associatedtype Key: FilterKey
    associatedtype CreatePayload: Encodable
    
    var id: Identifier { get }
    static var endpoint: Endpoint { get }

    static func list(client: ClientProtocol) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>]) async throws -> ResourceList<Self>
    static func read(client: ClientProtocol, id: Int) async throws -> Self
    static func read(client: ClientProtocol, id: Int, filters: [Filter<Key>]) async throws -> Self
    static func create(client: ClientProtocol, payload: CreatePayload) async throws -> Int
}

extension Resource {
    static func list(client: ClientProtocol) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [])
    }
    
    static func list(client: ClientProtocol, filters: [Filter<Key>]) async throws -> ResourceList<Self> {
        let data = try await client.get(endpoint: Self.endpoint, id: nil, filters: Filters(filters.map { AnyFilter($0) }))
        return try client.decode(data: data)
    }
    
    static func read(client: ClientProtocol, id: Int) async throws -> Self {
        try await read(client: client, id: id, filters: [])
    }
    
    static func read(client: ClientProtocol, id: Int, filters: [Filter<Key>]) async throws -> Self {
        let data = try await client.get(endpoint: Self.endpoint, id: id, filters: Filters(filters.map { AnyFilter($0) }))
        return try client.decode(data: data)
    }
    
    static func create(client: ClientProtocol, payload: CreatePayload) async throws -> Int {
        let data = try await client.post(endpoint: Self.endpoint, payload: payload)
        return try client.decode(data: data) as Int
    }
}
