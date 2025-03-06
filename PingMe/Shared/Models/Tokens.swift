import Foundation

struct Tokens: Codable {
    let access: TokenInfo
    let refresh: TokenInfo
}

struct TokenInfo: Codable {
    let token: String
    let expiresAt: Date

    enum CodingKeys: String, CodingKey {
        case token
        case expiresAt = "expires_at"
    }
}
