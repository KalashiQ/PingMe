import Foundation

struct Story: Identifiable {
    let id: UUID
    let username: String
    let avatarUrl: String?

    init(id: UUID = UUID(), username: String, avatarUrl: String? = nil) {
        self.id = id
        self.username = username
        self.avatarUrl = avatarUrl
    }
}
