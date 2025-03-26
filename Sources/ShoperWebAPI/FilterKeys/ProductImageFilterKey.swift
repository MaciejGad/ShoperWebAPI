import Foundation

public struct ProductImageFilterKey: FilterKey {
    public let rawValue: String
    
    public enum Parameter: String {
        /// file asset identifier
        case gfxId = "gfx_id"
        /// product identifier
        case productId = "product_id"
        /// photo order
        case order = "order"
        /// unique photo name, pointing to the file in filesystem
        case unicName = "unic_name"
        /// is the photo hidden
        case hidden = "hidden"
    }
        
    public enum Translation: String {
        /// translation identifier
        case translationId = "translation_id"
        /// file asset identifier
        case gfxId = "gfx_id"
        /// photo description
        case name = "name"
        /// language identifier
        case langId = "lang_id"
    }
    
    public static func translate(_ type: Translation, language: String) -> ProductImageFilterKey {
        return ProductImageFilterKey(rawValue: "translation.\(language).\(type.rawValue)")
    }
    
    public static func parameter(_ parameter: Parameter) -> ProductImageFilterKey {
        return ProductImageFilterKey(rawValue: parameter.rawValue)
    }
}

