import SwiftUI

struct ChatsView: View {
    @State private var viewModel = ChatsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                
                ScrollView {
                    VStack(spacing: 0) {
                        storiesSection
                        
                        chatsList
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                newChatButton
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("PingMe")
                .font(.title2)
                .bold()
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color(hex: "#CADDAD"))
    }
    
    private var storiesSection: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if let currentUser = viewModel.currentUser {
                        StoryView(story: currentUser, isCurrentUser: true)
                    }
                    
                    ForEach(viewModel.stories) { story in
                        StoryView(story: story)
                    }
                }
                .padding()
            }
        }
    }
    
    private var chatsList: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.chats) { chat in
                VStack(spacing: 0) {
                    ChatRowView(chat: chat)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    Divider()
                        .background(Color(uiColor: .systemGray5))
                }
            }
        }
    }
    
    private var newChatButton: some View {
        Button(action: {}) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(Color(hex: "#CADDAD"))
                .clipShape(Circle())
        }
        .padding()
    }
}

struct StoryView: View {
    let story: Story
    var isCurrentUser: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 60, height: 60)
                
                if isCurrentUser {
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 19, height: 19)
                            .background(Color.black)
                            .clipShape(Circle())
                            .position(x: 50, y: 47)
                        }
                    }
            }
            
            Text(story.username)
                .font(.caption)
                .lineLimit(1)
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.username)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(chat.lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formatTime(chat.lastMessageTime))
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ChatsView()
}
