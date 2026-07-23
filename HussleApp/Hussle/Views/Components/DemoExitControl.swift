import SwiftUI

struct DemoExitControl: View {
    @EnvironmentObject private var store: AppStore
    @State private var isExiting = false

    var body: some View {
        Button {
            guard !isExiting else { return }
            isExiting = true
            Task { await store.exitDemoMode() }
        } label: {
            Label("Exit Demo", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(HussleTheme.primary)
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(.white)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(HussleTheme.primary.opacity(0.18), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(isExiting)
        .accessibilityHint("Returns to the real Sign Up screen and resets Demo Mode")
        .accessibilityIdentifier("exitDemoButton")
    }
}

private struct DemoExitControlModifier: ViewModifier {
    @EnvironmentObject private var store: AppStore
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content.safeAreaInset(edge: .top, spacing: 0) {
            if isEnabled && store.isDemoMode {
                HStack {
                    Spacer()
                    DemoExitControl()
                }
                .padding(.horizontal, HussleTheme.screenPadding)
                .padding(.top, 4)
                .padding(.bottom, 2)
            }
        }
    }
}

extension View {
    func demoExitControl(isEnabled: Bool = true) -> some View {
        modifier(DemoExitControlModifier(isEnabled: isEnabled))
    }
}
