import Foundation

public struct Attributes: Codable {
    public let values: [String: Attribute]
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicKey.self) {
            var values: [String: Attribute] = [:]
            for key in container.allKeys {
                let value = try container.decode(Attribute.self, forKey: key)
                values[key.stringValue] = value
            }
            self.values = values
        } else {
            values = [:]
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        for (key, value) in values {
            let key = DynamicKey(stringValue: key)
            try container.encode(value, forKey: key)
        }
    }
}

public struct Attribute: Codable {
    public let values: [String: String]
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicKey.self) {
            var values: [String: String] = [:]
            for key in container.allKeys {
                let value = try container.decode(String.self, forKey: key)
                values[key.stringValue] = value
            }
            self.values = values
        } else {
            values = [:]
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        for (key, value) in values {
            let key = DynamicKey(stringValue: key)
            try container.encode(value, forKey: key)
        }
    }
}


//{"5":{"16":"TAK","15":"30\u00b0C","14":"TAK","10":"100% bawe\u0142na"},"6":{"22":"Tak","19":"Zamek b\u0142yskawiczny","18":"Kolor jednolity"},"7":{"26":"Standardowa","23":"Regular Fit"}}

// {"5":[],"6":[],"7":[]}
