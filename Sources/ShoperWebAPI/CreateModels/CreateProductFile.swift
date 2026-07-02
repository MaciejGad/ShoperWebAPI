import Foundation

/// Payload for uploading a file bound to a product translation.
public struct CreateProductFile: Encodable, Sendable {
    public var translationId: Int
    public var fileName: String
    /// Base64-encoded file contents.
    public var content: String
    public var description: String?
    public var active: Bool?
    /// File type: 0 - regular file, 1 - file containing product safety information.
    public var type: Int?

    public init(
        translationId: Int,
        fileName: String,
        content: String,
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

    /// Convenience initializer that base64-encodes raw file data.
    public static func file(
        content: Data,
        translationId: Int,
        fileName: String,
        description: String? = nil,
        active: Bool? = nil,
        type: Int? = nil
    ) -> CreateProductFile {
        .init(
            translationId: translationId,
            fileName: fileName,
            content: content.base64EncodedString(),
            description: description,
            active: active,
            type: type
        )
    }
}
