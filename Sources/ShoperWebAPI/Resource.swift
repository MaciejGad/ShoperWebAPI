import Foundation

public protocol Resource: Decodable {
    associatedtype Key: FilterKey
    associatedtype CreatePayload: Encodable
    associatedtype UpdatePayload: Encodable
    
    var id: Identifier { get }
    static var endpoint: Endpoint { get }
    
    static func list(client: ClientProtocol) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, page: Int?) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>]) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>], page: Int?) async throws -> ResourceList<Self>
    static func get(client: ClientProtocol, id: Int) async throws -> Self
    static func create(client: ClientProtocol, payload: CreatePayload) async throws -> Int
    static func update(client: ClientProtocol, id: Int, payload: UpdatePayload) async throws
}

extension Resource {
    
    static public func list(client: ClientProtocol) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [], page: nil)
    }
    
    static public func list(client: ClientProtocol, page: Int?) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [], page: page)
    }
    
    static public func list(client: ClientProtocol, filters: [Filter<Key>]) async throws -> ResourceList<Self> {
        try await list(client: client, filters: filters, page: nil)
    }
    
    static public func list(client: ClientProtocol, filters: [Filter<Key>], page: Int?) async throws -> ResourceList<Self> {
        let data = try await client.get(endpoint: Self.endpoint, id: nil, filters: Filters(filters.map { AnyFilter($0) }), page: page)
        return try client.decode(data: data)
    }
    
    static public func get(client: ClientProtocol, id: Int) async throws -> Self {
        let data = try await client.get(endpoint: Self.endpoint, id: id, filters: nil, page: nil)
        return try client.decode(data: data)
    }
    
    static public func create(client: ClientProtocol, payload: CreatePayload) async throws -> Int {
        let data = try await client.post(endpoint: Self.endpoint, payload: payload)
        return try client.decode(data: data) as Int
    }
    
    static public func update(client: ClientProtocol, id: Int, payload: UpdatePayload) async throws {
        _ = try await client.put(endpoint: Self.endpoint, id: id, payload: payload)
    }
}
