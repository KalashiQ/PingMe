extension String {
    func localized(_ args: CVarArg...) -> String {
        String(format: "\(self)", arguments: args)
    }

    var localized: String {
        String(localized: "\(self)")
    }
}
