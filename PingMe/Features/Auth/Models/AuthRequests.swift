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
