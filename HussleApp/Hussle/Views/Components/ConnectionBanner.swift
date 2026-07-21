import SwiftUI

struct ConnectionBanner: View {
    let isConnected: Bool
    let message: String?
    let onDismissError: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if !isConnected {
                Label("You’re offline. Some features may be unavailable.", systemImage: "wifi.slash")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(Color.orange)
                    .accessibilityIdentifier("offlineBanner")
            }
            if let message, !message.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(message).font(.footnote).lineLimit(2)
                    Spacer()
                    Button(action: onDismissError) {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Dismiss error")
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.92))
                .accessibilityIdentifier("errorBanner")
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isConnected)
        .animation(.easeInOut(duration: 0.2), value: message)
    }
}
