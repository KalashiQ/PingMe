import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var backgroundOpacity = 0.0
    @State private var bellsScale = 0.3
    @State private var bellsOpacity = 0.0
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    @State private var taglineOffset = 20.0
    @State private var taglineOpacity = 0.0
    
    var body: some View {
        if isActive {
            LoginView()
        } else {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(backgroundOpacity)
                
                VStack(spacing: 20) {
                    Image("Notifications")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .scaleEffect(bellsScale)
                        .opacity(bellsOpacity)
                    
                    Image("PingMe")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Image("StayConnected")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .offset(y: taglineOffset)
                        .opacity(taglineOpacity)
                }
                .offset(y: -50)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    backgroundOpacity = 1.0
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3)) {
                    bellsScale = 1.0
                    bellsOpacity = 1.0
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5)) {
                    logoScale = 1.0
                    logoOpacity = 1.0
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.7)) {
                    taglineOffset = 0
                    taglineOpacity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        backgroundOpacity = 0
                        bellsOpacity = 0
                        logoOpacity = 0
                        taglineOpacity = 0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

