import Foundation

extension String {
    func localized(_ args: CVarArg...) -> String {
        let localizedFormat = NSLocalizedString(self, comment: "")
        return String(format: localizedFormat, arguments: args)
    }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
