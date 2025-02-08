import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale = 1.1
    
    var body: some View {
        if isActive {
            LoginView()
        } else {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(opacity)
                    .scaleEffect(scale)
            }
            .onAppear {
                // Быстрое появление
                withAnimation(.easeOut(duration: 0.4)) {
                    self.opacity = 1.0
                    self.scale = 1.0
                }
                
                // Быстрое исчезновение
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        self.opacity = 0.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

