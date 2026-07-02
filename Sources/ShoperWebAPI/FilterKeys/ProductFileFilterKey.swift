import Foundation

public struct ProductFileFilterKey: FilterKey {
    public let rawValue: String

    public enum Parameter: String {
        /// product translation identifier this file is bound to
        case translationId = "translation_id"
        /// is file enabled
        case active = "active"
        /// unique filename
        case fileName = "file_name"
        /// file type (0 - regular file, 1 - product safety information)
        case type = "type"
    }

    public static func parameter(_ parameter: Parameter) -> ProductFileFilterKey {
        return ProductFileFilterKey(rawValue: parameter.rawValue)
    }
}

extension Filter where Key == ProductFileFilterKey {
    public static func translationId(_ value: Int) -> Filter<Key> {
        return .init(key: .parameter(.translationId), value: .equal("\(value)"))
    }
}
