import SwiftUI

struct BackgroundView: View {
    var height: CGFloat
    var width: CGFloat = 400
    var body: some View {
        RoundedRectangle(cornerRadius: 52)
            .fill(Color(hex: "#CADDAD"))
            .frame(width: width, height: height)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(height: 745)
    }
}
