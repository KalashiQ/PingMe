import SwiftUI

struct BackgroundView: View {
    var height: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 52)
            .fill(Color(hex: "#CADDAD"))
            .frame(width: .infinity, height: height)
            .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(height: 745)
    }
}
