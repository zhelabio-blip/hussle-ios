import SwiftUI

struct MessagesView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            if store.matchSummaries.isEmpty {
                ContentUnavailableView(
                    "No messages",
                    systemImage: "message",
                    description: Text("Chats appear after a mutual match.")
                )
            } else {
                ForEach(store.matchSummaries) { match in
                    NavigationLink {
                        ChatView(match: match)
                    } label: {
                        HStack(spacing: 20) {
                            DogOwnerPortrait(dog: match.dog, dogSize: 60, ownerSize: 26)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(match.dog.name).font(.headline)
                                Text(match.lastMessage ?? "Start a conversation")
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Messages")
        .refreshable { await store.refreshMatches() }
        .task { await store.refreshMatches() }
    }
}

struct ChatView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    let match: MatchSummary
    @State private var draft = ""
    @State private var showReport = false
    @State private var showUnmatch = false
    @State private var showBlock = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        Text("You matched \(match.matchedAt.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)

                        ForEach(store.messages) { message in
                            MessageBubble(message: message).id(message.id)
                        }

                        if store.isLoadingMessages { ProgressView().padding() }
                    }
                    .padding()
                }
                .onChange(of: store.messages.count) { _, _ in
                    if let last = store.messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } }
                }
            }

            HStack(spacing: 10) {
                TextField("Message…", text: $draft, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                Button {
                    let outgoing = draft
                    draft = ""
                    Task { await store.sendMessage(outgoing, conversationID: match.conversationID) }
                } label: {
                    if store.isSendingMessage { ProgressView().tint(.white) } else { Image(systemName: "paperplane.fill") }
                }
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(HussleTheme.accent)
                .clipShape(Circle())
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || store.isSendingMessage)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .background(HussleTheme.background)
        .navigationTitle(match.dog.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 10) {
                    DogOwnerPortrait(dog: match.dog, dogSize: 34, ownerSize: 16)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(match.dog.name).font(.headline)
                        Text(match.dog.ownerName).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink { DogProfileView(dog: match.dog) } label: { Label("View dog profile", systemImage: "pawprint") }
                    Button("Unmatch", systemImage: "heart.slash") { showUnmatch = true }
                    Button("Report", systemImage: "exclamationmark.bubble") { showReport = true }
                    Button("Block owner", systemImage: "person.crop.circle.badge.xmark", role: .destructive) { showBlock = true }
                } label: { Image(systemName: "ellipsis") }
            }
        }
        .sheet(isPresented: $showReport) { ReportView(dog: match.dog, ownerID: match.otherOwnerID) }
        .confirmationDialog("Unmatch with \(match.dog.name)?", isPresented: $showUnmatch, titleVisibility: .visible) {
            Button("Unmatch", role: .destructive) {
                Task { if await store.unmatch(match) { dismiss() } }
            }
            Button("Cancel", role: .cancel) {}
        } message: { Text("You will no longer be able to message this owner.") }
        .confirmationDialog("Block \(match.dog.ownerName)?", isPresented: $showBlock, titleVisibility: .visible) {
            Button("Block owner", role: .destructive) {
                Task { if await store.block(ownerID: match.otherOwnerID, dog: match.dog) { dismiss() } }
            }
            Button("Cancel", role: .cancel) {}
        } message: { Text("The match will close and you will no longer see each other.") }
        .task {
            await store.loadConversation(match.conversationID)
            await store.startRealtimeChat(conversationID: match.conversationID)
        }
        .onDisappear {
            Task { await store.stopRealtimeChat() }
        }
    }
}

private struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer(minLength: 52) }
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .foregroundStyle(message.isFromCurrentUser ? .white : HussleTheme.text)
                    .background(message.isFromCurrentUser ? HussleTheme.primary : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Text(message.timestamp).font(.caption2).foregroundStyle(.secondary)
            }
            if !message.isFromCurrentUser { Spacer(minLength: 52) }
        }
    }
}
