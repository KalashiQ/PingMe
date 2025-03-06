import Foundation

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let error: String?
}
