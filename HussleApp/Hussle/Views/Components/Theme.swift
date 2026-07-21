import SwiftUI

enum HussleTheme {
    static let primary = Color(red: 0.42, green: 0.25, blue: 0.78)
    static let accent = Color(red: 1.0, green: 0.24, blue: 0.48)
    static let background = Color(red: 0.985, green: 0.98, blue: 1.0)
    static let text = Color(red: 0.08, green: 0.07, blue: 0.18)
    static let secondaryText = Color.secondary
    static let radius: CGFloat = 24
    static let screenPadding: CGFloat = 24
    static let contentSpacing: CGFloat = 18
    static let compactSpacing: CGFloat = 8
    static let rowSpacing: CGFloat = 18
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(isEnabled ? HussleTheme.primary : Color.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.white)
            .overlay {
                Capsule()
                    .stroke(isEnabled ? HussleTheme.primary.opacity(0.28) : Color.gray.opacity(0.20), lineWidth: 1.5)
            }
            .clipShape(Capsule())
            .opacity(configuration.isPressed && isEnabled ? 0.72 : 1)
    }
}
