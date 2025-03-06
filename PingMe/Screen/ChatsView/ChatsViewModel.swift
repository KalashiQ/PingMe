import Foundation
import Observation

@Observable
class ChatsViewModel {
    var chats: [Chat] = []
    var stories: [Story] = []
    var currentUser: Story?
    var isSlideBarShowing: Bool = false
    var currentUserName: String = "Имя пользователя"
    var username: String = "username"

    init() {
        setupMockData()
    }

    private func setupMockData() {
        currentUser = Story(username: "My name", avatarUrl: nil)

        stories = [
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
        ]

        chats = [
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -120)),
            Chat(
                username: "Group name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -240)),
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -7200), isGroup: true),
            Chat(
                username: "Group name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -14400), isGroup: true),
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -21600)),
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(
                username: "Group name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(
                username: "Group name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(
                username: "Group name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
            Chat(
                username: "Name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(
                username: "Group name", lastMessage: "last message...",
                lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
        ]
    }
}
