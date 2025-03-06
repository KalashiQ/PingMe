import SwiftUI

// MARK: - Main View
struct ChatView: View {
    @State private var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool

    // MARK: - Initialization
    init(recipientName: String) {
        _viewModel = State(initialValue: ChatViewModel(recipientName: recipientName))
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                chatContent
            }
            .scrollDismissesKeyboard(.immediately)
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        isInputFocused = false
                    }
            )

            messageInputField
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "#CADDAD").opacity(0.8), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }

    // MARK: - UI Components
    private var header: some View {
        HStack(spacing: 16) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }

            Circle()
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.recipientName)
                    .font(.system(size: 16, weight: .semibold))

                HStack(spacing: 4) {
                    Circle()
                        .fill(viewModel.isRecipientOnline ? .green : .gray)
                        .frame(width: 8, height: 8)

                    Text(viewModel.isRecipientOnline ? "online" : "offline")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            VStack(spacing: 2) {
                Image(systemName: "bell")
                Text("PingMe")
                    .font(.caption)
            }

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.title2)
            }
        }
        .padding()
        .foregroundColor(.black)
        .background(Color(hex: "#CADDAD"))
    }

    // MARK: - Chat Content
    private var chatContent: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.messages) { message in
                MessageBubble(message: message)
            }
        }
        .padding()
    }

    // MARK: - Message Input
    private var messageInputField: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Image(systemName: "paperclip")
                    .font(.title2)
            }

            TextField("Введите сообщение...", text: $viewModel.newMessageText)
                .padding(8)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(20)
                .focused($isInputFocused)
                .onSubmit {
                    viewModel.sendMessage()
                }

            if viewModel.newMessageText.isEmpty {
                Button(action: {}) {
                    Image(systemName: "mic")
                        .font(.title2)
                }

                Button(action: {}) {
                    Image(systemName: "video")
                        .font(.title2)
                }
            } else {
                Button(action: {
                    viewModel.sendMessage()
                    isInputFocused = false
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#CADDAD"))
                }
            }
        }
        .padding()
        .foregroundColor(.black)
    }
}

// MARK: - Message Bubble Component
struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }

            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .padding(.bottom, 16)
                    .overlay(
                        Text(message.timestamp.formattedTime())
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding([.trailing, .bottom], 8),
                        alignment: .bottomTrailing
                    )
                    .background(message.isFromCurrentUser ? Color(uiColor: .systemGray5) : .white)
                    .cornerRadius(20)
            }

            if !message.isFromCurrentUser { Spacer() }
        }
    }
}

// MARK: - Preview
#Preview {
    ChatView(recipientName: "Тестовый пользователь")
}
