import Foundation

public protocol Resource: Decodable, Sendable {
    associatedtype Key: FilterKey
    associatedtype Sort: SortKey
    associatedtype CreatePayload: Encodable
    associatedtype UpdatePayload: Encodable
    
    var id: Identifier { get }
    static var endpoint: Endpoint { get }
    
    static func list(client: ClientProtocol) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, page: Int?) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>]) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>], page: Int?) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, sort: [Order<Sort>]) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, sort: [Order<Sort>], page: Int?) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>], sort: [Order<Sort>], page: Int?) async throws -> ResourceList<Self>
    static func list(client: ClientProtocol, filters: [Filter<Key>], sort: [Order<Sort>], page: Int?, limit: Int?) async throws -> ResourceList<Self>
    static func get(client: ClientProtocol, id: Int) async throws -> Self
    static func create(client: ClientProtocol, payload: CreatePayload) async throws -> Int
    static func update(client: ClientProtocol, id: Int, payload: UpdatePayload) async throws
}

extension Resource {
    
    static public func list(client: ClientProtocol) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [], sort: [], page: nil)
    }
    
    static public func list(client: ClientProtocol, page: Int?) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [], sort: [], page: page)
    }
    
    static public func list(client: ClientProtocol, filters: [Filter<Key>]) async throws -> ResourceList<Self> {
        try await list(client: client, filters: filters, sort: [], page: nil, limit: nil)
    }
    
    static public func list(client: ClientProtocol, filters: [Filter<Key>], page: Int?) async throws -> ResourceList<Self> {
        try await list(client: client, filters: filters, sort: [], page: page, limit: nil)
    }
    
    static public func list(client: ClientProtocol, sort: [Order<Sort>]) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [], sort: sort, page: nil, limit: nil)
    }
    
    static public func list(client: ClientProtocol, sort: [Order<Sort>], page: Int?) async throws -> ResourceList<Self> {
        try await list(client: client, filters: [], sort: sort, page: page, limit: nil)
    }
    
    static public func list(client: ClientProtocol, filters: [Filter<Key>], sort: [Order<Sort>], page: Int?) async throws -> ResourceList<Self> {
        try await list(client: client, filters: filters, sort: sort, page: page, limit: nil)
    }

    static public func list(client: ClientProtocol, filters: [Filter<Key>], sort: [Order<Sort>], page: Int?, limit: Int?) async throws -> ResourceList<Self> {
        let data = try await client.get(endpoint: Self.endpoint, id: nil, filters: Filters(filters.map { AnyFilter($0) }), sort: .init(sort), page: page, limit: limit)
        return try client.decode(data: data)
    }
    
    static public func get(client: ClientProtocol, id: Int) async throws -> Self {
        let data = try await client.get(endpoint: Self.endpoint, id: id, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }
    
    static public func create(client: ClientProtocol, payload: CreatePayload) async throws -> Int {
        let data = try await client.post(endpoint: Self.endpoint, payload: payload)
        return try client.decode(data: data) as Int
    }
    
    static public func update(client: ClientProtocol, id: Int, payload: UpdatePayload) async throws {
        _ = try await client.put(endpoint: Self.endpoint, id: id, payload: payload)
    }

    static public func listAll(
        client: ClientProtocol,
        filters: [Filter<Key>] = [],
        sort: [Order<Sort>] = [],
        limit: Int = 50,
        maxPages: Int = 200
    ) async throws -> [Self] {
        var all: [Self] = []
        for page in 1...maxPages {
            let result = try await list(client: client, filters: filters, sort: sort, page: page, limit: limit)
            all.append(contentsOf: result.list)
            if result.list.count < limit || page >= result.pages { break }
        }
        return all
    }
}
