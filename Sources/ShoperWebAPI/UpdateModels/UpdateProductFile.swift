import Foundation

public struct UpdateProductFile: Encodable, Sendable {
    public var translationId: Int?
    public var fileName: String?
    /// Base64-encoded file contents.
    public var content: String?
    public var description: String?
    public var active: Bool?
    /// File type: 0 - regular file, 1 - file containing product safety information.
    public var type: Int?

    public init(
        translationId: Int? = nil,
        fileName: String? = nil,
        content: String? = nil,
        description: String? = nil,
        active: Bool? = nil,
        type: Int? = nil
    ) {
        self.translationId = translationId
        self.fileName = fileName
        self.content = content
        self.description = description
        self.active = active
        self.type = type
    }
}
