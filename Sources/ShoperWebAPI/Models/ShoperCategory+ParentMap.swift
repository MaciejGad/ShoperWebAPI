import Foundation

extension ShoperCategory {
    /// Fetches the full category tree and builds a `categoryId -> parentId` map.
    /// Pair this with `ShoperCategory.listAll(client:)` results — the `/categories` endpoint
    /// alone doesn't reliably expose parent relationships, only `/categories-tree` does.
    public static func fetchParentMap(client: ClientProtocol) async throws -> [Int: Int] {
        let nodes = try await CategoryTreeNode.listAll(client: client)
        return CategoryTreeNode.buildParentMap(nodes: nodes)
    }
}
