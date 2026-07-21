import SwiftUI
import UIKit

struct AuthView: View {
    @EnvironmentObject private var store: AppStore
    @State private var mode: Mode = .signUp
    @State private var email = ""
    @State private var password = ""
    @State private var attemptedSubmit = false

    enum Mode: String, CaseIterable { case signUp = "Sign Up", logIn = "Log In" }

    var body: some View {
        ZStack {
            HussleTheme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 22) {
                    Spacer(minLength: 28)
                    Text("Hussle")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(HussleTheme.primary)
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 72)).foregroundStyle(HussleTheme.accent)
                    Text("Meaningful matches for happy dogs")
                        .font(.title2.bold()).multilineTextAlignment(.center)

                    Picker("Mode", selection: $mode) {
                        ForEach(Mode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: mode) { _, _ in
                        attemptedSubmit = false
                        store.dismissAuthFeedback()
                    }

                    FormGuidanceBanner(text: "Enter both required fields to continue.")

                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 7) {
                            RequiredFieldLabel(title: "Email")
                            TextField("name@example.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .requiredFieldBorder(showError: attemptedSubmit && !emailLooksValid)
                            if attemptedSubmit && !emailLooksValid {
                                InlineValidationMessage(text: email.isEmpty ? "Enter your email address." : "Enter a valid email address.")
                            }
                        }

                        VStack(alignment: .leading, spacing: 7) {
                            RequiredFieldLabel(title: "Password")
                            SecureField("At least 6 characters", text: $password)
                                .textContentType(mode == .signUp ? .newPassword : .password)
                                .requiredFieldBorder(showError: attemptedSubmit && password.count < 6)
                            if attemptedSubmit && password.count < 6 {
                                InlineValidationMessage(text: "Password must contain at least 6 characters.")
                            }
                        }
                    }

                    if let notice = store.authNotice {
                        Label(notice, systemImage: "envelope.badge")
                            .font(.footnote)
                            .foregroundStyle(HussleTheme.primary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(HussleTheme.primary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    if let error = store.authError {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(Color.red.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Button(store.isAuthenticating ? "Please wait…" : mode.rawValue) {
                        submit()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(store.isAuthenticating)
                    .accessibilityHint("Shows missing required information if the form is incomplete")

                    VStack(spacing: 10) {
                        HStack(spacing: 12) {
                            Rectangle().fill(Color.secondary.opacity(0.18)).frame(height: 1)
                            Text("or").font(.caption).foregroundStyle(.secondary)
                            Rectangle().fill(Color.secondary.opacity(0.18)).frame(height: 1)
                        }

                        Button("Explore Demo Mode") { store.continueInDemoMode() }
                            .buttonStyle(SecondaryButtonStyle())
                            .accessibilityIdentifier("demoModeButton")

                        Text("Preview the complete Hussle experience with sample dogs. No account or internet connection is required.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
    }

    private var emailLooksValid: Bool {
        let value = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.contains("@") && value.contains(".") && value.count >= 5
    }

    private func submit() {
        guard emailLooksValid, password.count >= 6 else {
            attemptedSubmit = true
            UIAccessibility.post(notification: .announcement, argument: "Complete the required email and password fields.")
            return
        }
        attemptedSubmit = false
        Task {
            if mode == .signUp { await store.signUp(email: email, password: password) }
            else { await store.signIn(email: email, password: password) }
        }
    }
}
