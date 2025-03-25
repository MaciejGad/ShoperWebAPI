import Foundation

protocol FilterValueType: Encodable {}

extension Int: FilterValueType {}
extension String: FilterValueType {}
extension [Int]: FilterValueType {}
