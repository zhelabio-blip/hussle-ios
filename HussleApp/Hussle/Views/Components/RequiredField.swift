import SwiftUI

struct RequiredFieldLabel: View {
    let title: String
    var isRequired = true

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            if isRequired {
                Text("Required")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(HussleTheme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(HussleTheme.accent.opacity(0.10))
                    .clipShape(Capsule())
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct InlineValidationMessage: View {
    let text: String

    var body: some View {
        Label(text, systemImage: "exclamationmark.circle.fill")
            .font(.caption)
            .foregroundStyle(.red)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityLabel("Required. \(text)")
    }
}

struct FormGuidanceBanner: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(HussleTheme.primary)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(HussleTheme.primary.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension View {
    func requiredFieldBorder(showError: Bool) -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(showError ? Color.red : HussleTheme.primary.opacity(0.42), lineWidth: showError ? 1.6 : 1.2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
