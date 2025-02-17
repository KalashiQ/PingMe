import Foundation
import Observation

@Observable
class ChatViewModel {
    var messages: [Message] = []
    var recipientName: String
    var isRecipientOnline: Bool
    var newMessageText: String = ""
    
    init(recipientName: String, isRecipientOnline: Bool = true) {
        self.recipientName = recipientName
        self.isRecipientOnline = isRecipientOnline
        setupMockMessages()
    }
    
    func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        
        let message = Message(
            content: newMessageText,
            timestamp: Date(),
            isFromCurrentUser: true
        )
        messages.append(message)
        newMessageText = ""
    }
    
    private func setupMockMessages() {
        messages = [
            Message(content: "Привет!", timestamp: Date(timeIntervalSinceNow: -3600), isFromCurrentUser: false),
            Message(content: "Здравствуй!", timestamp: Date(timeIntervalSinceNow: -3500), isFromCurrentUser: true),
            Message(content: "Как дела?", timestamp: Date(timeIntervalSinceNow: -3400), isFromCurrentUser: false),
            Message(content: "Отлично, спасибо! У тебя как?", timestamp: Date(timeIntervalSinceNow: -3300), isFromCurrentUser: true)
        ]
    }
} 
