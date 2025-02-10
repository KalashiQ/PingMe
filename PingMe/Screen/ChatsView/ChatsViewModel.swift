import Foundation
import Observation

@Observable
class ChatsViewModel {
    var chats: [Chat] = []
    var stories: [Story] = []
    var currentUser: Story?
    
    init() {
        setupMockData()
    }
    
    private func setupMockData() {
        // Мок данные для текущего пользователя
        currentUser = Story(username: "My name", avatarUrl: nil)
        
        // Мок данные для историй
        stories = [
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil),
            Story(username: "Name", avatarUrl: nil)
        ]
        
        // Мок данные для чатов
        chats = [
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -120)),
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -240)),
            Chat(username: "Group name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -7200), isGroup: true),
            Chat(username: "Group name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -14400), isGroup: true),
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -21600)),
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(username: "Group name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(username: "Group name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(username: "Group name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true),
            Chat(username: "Name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -36000)),
            Chat(username: "Group name", lastMessage: "last message...", lastMessageTime: Date(timeIntervalSinceNow: -43200), isGroup: true)
        ]
    }
}

