import Foundation

struct RegisterResponseData: Codable {
    let email: String
}

struct VerifyResponseData: Codable {
    let user: User
    let tokens: Tokens
}
