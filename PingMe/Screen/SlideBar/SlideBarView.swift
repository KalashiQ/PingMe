import SwiftUI

struct SlideBarView: View {
    @Binding var isShowing: Bool
    let currentUserName: String
    let username: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isShowing {
                Color.black.opacity(0.0001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
            }
            
            GeometryReader { geometry in
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(hex: "#CADDAD"))
                            .frame(width: 60, height: 60)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUserName)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text("@\(username)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 100)
                    
                    VStack(spacing: 12) {
                        Button(action: {}) {
                            HStack {
                                Text("Редактировать профиль")
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#444444"))
                            .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Text("\"Внезапная встреча\"")
                                    .font(.system(size: 16))
                                Spacer()
                                Image(systemName: "plus")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#444444"))
                            .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Text("PingMe")
                                    .font(.system(size: 16))
                                Spacer()
                                Image(systemName: "plus")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#444444"))
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack {
                            Text("Настройки")
                                .font(.system(size: 16))
                            Spacer()
                            Image(systemName: "gearshape.fill")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "#444444"))
                        .cornerRadius(12)
                    }
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
                .frame(width: min(geometry.size.width * 0.8, 300))
                .background(
                    Rectangle()
                        .fill(Color.black)
                        .padding(.leading, -50)

                )
                .offset(x: isShowing ? 0 : -(geometry.size.width))
            }
            .ignoresSafeArea()
        }
        .transition(.move(edge: .leading))
        .animation(.spring(response: 0.2, dampingFraction: 1.5), value: isShowing)
    }
}
