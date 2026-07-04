import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    static func delete(client: ClientProtocol, id: Int) async throws -> Bool
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

    /// Deletes the resource. Returns `true` if a resource was deleted, `false` if nothing
    /// matched `id`.
    ///
    /// Note: the OpenAPI spec documents the response as a raw `1`/`0` body for "deleted" vs.
    /// "nothing to delete", but the live API actually returns HTTP 404 when `id` doesn't exist
    /// (confirmed by deleting the same resource twice) rather than a `0` body. Both outcomes are
    /// treated as `false` here so the method's contract holds regardless of which behavior the
    /// server exhibits for a given resource type.
    static public func delete(client: ClientProtocol, id: Int) async throws -> Bool {
        do {
            let data = try await client.delete(endpoint: Self.endpoint, id: id)
            let result: Int = try client.decode(data: data)
            return result == 1
        } catch let error as ShoperError {
            // A cast-in-`where`-clause here (`catch let ... where (x as? HTTPURLResponse)...`)
            // fails to compile on Linux's swift-corelibs-foundation (Swift 6.0/Ubuntu jammy):
            // the compiler treats the conditional cast as always succeeding but then can't see
            // `.statusCode` on the result. Using a plain `if case`/`if let` inside the catch body
            // avoids the issue and works identically on both platforms.
            if case .invalidResponse(_, let response) = error,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 404 {
                return false
            }
            throw error
        }
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
