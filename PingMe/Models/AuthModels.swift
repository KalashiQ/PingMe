import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
}

struct VerifyRegistrationRequest: Codable {
    let email: String
    let password: String
    let token: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct VerifyLoginRequest: Codable {
    let email: String
    let password: String
    let token: String
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let error: String?
}

struct RegisterResponseData: Codable {
    let email: String
}

struct User: Codable {
    let id: UUID
    let email: String
    let name: String
    let username: String?
    let phoneNumber: String?
    let isOnline: Bool
    let isVerified: Bool
    let authProvider: String
    let mailingMethod: String
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, email, name, username
        case phoneNumber = "phone_number"
        case isOnline = "is_online"
        case isVerified = "is_verified"
        case authProvider = "auth_provider"
        case mailingMethod = "mailing_method"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

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

struct VerifyResponseData: Codable {
    let user: User
    let tokens: Tokens
}
