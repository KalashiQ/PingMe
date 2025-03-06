import Foundation
import Observation

// MARK: - View Model
@Observable
class ChatViewModel {
    var messages: [Message] = []
    var recipientName: String
    var isRecipientOnline: Bool
    var newMessageText: String = ""

    // MARK: - Initialization
    init(recipientName: String, isRecipientOnline: Bool = true) {
        self.recipientName = recipientName
        self.isRecipientOnline = isRecipientOnline
        setupMockMessages()
    }

    // MARK: - Message Management
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

    // MARK: - Mock Data Setup
    private func setupMockMessages() {
        messages = [
            Message(
                content: "Привет!", timestamp: Date(timeIntervalSinceNow: -3600),
                isFromCurrentUser: false),
            Message(
                content: "Здравствуй!", timestamp: Date(timeIntervalSinceNow: -3500),
                isFromCurrentUser: true),
            Message(
                content: "Как дела?", timestamp: Date(timeIntervalSinceNow: -3400),
                isFromCurrentUser: false),
            Message(
                content: "Отлично, спасибо! У тебя как?",
                timestamp: Date(timeIntervalSinceNow: -3300), isFromCurrentUser: true),
        ]
    }
}
