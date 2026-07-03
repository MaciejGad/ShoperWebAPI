import Foundation

public struct UpdateUser: Encodable, Sendable {
    public var email: String?
    public var firstname: String?
    public var lastname: String?
    /// Password, at least 12 characters.
    public var password: String?
    public var active: Bool?
    public var comment: String?
    public var discount: Decimal?
    public var groupId: Int?
    /// Unlike the read model's `tags` (an array), update accepts a single string value.
    public var tags: String?
    public var verifyEmail: Bool?

    public init(
        email: String? = nil,
        firstname: String? = nil,
        lastname: String? = nil,
        password: String? = nil,
        active: Bool? = nil,
        comment: String? = nil,
        discount: Decimal? = nil,
        groupId: Int? = nil,
        tags: String? = nil,
        verifyEmail: Bool? = nil
    ) {
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.password = password
        self.active = active
        self.comment = comment
        self.discount = discount
        self.groupId = groupId
        self.tags = tags
        self.verifyEmail = verifyEmail
    }
}
