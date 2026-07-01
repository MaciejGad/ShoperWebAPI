import Foundation

public struct CategoryTreeNode: Decodable, Sendable {
    public let id: Int
    public let children: [CategoryTreeNode]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.children = (try? container.decode([CategoryTreeNode].self, forKey: .children)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case id
        case children
    }
}

// MARK: - Parent map

extension CategoryTreeNode {
    /// Builds a mapping of childId -> parentId from a list of root nodes.
    public static func buildParentMap(nodes: [CategoryTreeNode]) -> [Int: Int] {
        var result: [Int: Int] = [:]
        for node in nodes {
            collectParents(node: node, parentId: nil, into: &result)
        }
        return result
    }

    private static func collectParents(node: CategoryTreeNode, parentId: Int?, into result: inout [Int: Int]) {
        if let parentId {
            result[node.id] = parentId
        }
        for child in node.children {
            collectParents(node: child, parentId: node.id, into: &result)
        }
    }
}

// MARK: - List API
// The /webapi/rest/categories-tree endpoint returns a plain JSON array, not a paginated object.

extension CategoryTreeNode {
    public static func listAll(client: ClientProtocol) async throws -> [CategoryTreeNode] {
        let data = try await client.get(endpoint: .categoriesTree, id: nil, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }
}
