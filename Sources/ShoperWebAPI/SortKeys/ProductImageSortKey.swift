import Foundation

/// Sort keys available for product image queries
public enum ProductImageSortKey: SortKey {
    /// File asset identifier
    case gfxId
    /// Product identifier
    case productId
    /// Is the photo set as main
    case main
    /// Photo order
    case order
    /// Unique photo name, pointing to the file in filesystem
    case unicName
    /// Is the photo hidden
    case hidden
    /// File extension
    case `extension`
    /// Product image translations
    case translations
    /// Translation identifier for specific locale
    case translationId(String)
    /// File asset identifier for specific locale
    case translationGfxId(String)
    /// Photo description SEO for specific locale
    case translationName(String)
    /// Photo description availability for specific locale
    case translationDescription(String)
    /// Language identifier for specific locale
    case translationLangId(String)
    /// Object creation datetime in ISO_8601 format
    case createdAt
    /// Latest object modification datetime in ISO_8601 format
    case updatedAt
    
    /// Returns the string value for the sort key
    public var rawValue: String {
        switch self {
        case .gfxId: return "gfx_id"
        case .productId: return "product_id"
        case .main: return "main"
        case .order: return "order"
        case .unicName: return "unic_name"
        case .hidden: return "hidden"
        case .`extension`: return "extension"
        case .translations: return "translations"
        case .translationId(let locale): return "translations.\(locale).translation_id"
        case .translationGfxId(let locale): return "translations.\(locale).gfx_id"
        case .translationName(let locale): return "translations.\(locale).name"
        case .translationDescription(let locale): return "translations.\(locale).description"
        case .translationLangId(let locale): return "translations.\(locale).lang_id"
        case .createdAt: return "created_at"
        case .updatedAt: return "updated_at"
        }
    }
}
