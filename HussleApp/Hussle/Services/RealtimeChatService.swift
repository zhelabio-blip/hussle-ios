import Foundation

actor RealtimeChatService {
    enum RealtimeError: Error { case invalidURL }

    private var task: URLSessionWebSocketTask?
    private var listenTask: Task<Void, Never>?

    func connect(configuration: BackendConfiguration, accessToken: String, conversationID: UUID, onChange: @escaping @Sendable () async -> Void) throws {
        disconnect()
        guard let base = configuration.projectURL,
              var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else { throw RealtimeError.invalidURL }
        components.scheme = base.scheme == "https" ? "wss" : "ws"
        components.path = "/realtime/v1/websocket"
        components.queryItems = [
            URLQueryItem(name: "apikey", value: configuration.anonKey),
            URLQueryItem(name: "vsn", value: "1.0.0")
        ]
        guard let url = components.url else { throw RealtimeError.invalidURL }

        let socket = URLSession.shared.webSocketTask(with: url)
        task = socket
        socket.resume()

        let topic = "realtime:public:messages:conversation_id=eq.\(conversationID.uuidString.lowercased())"
        let join: [String: Any] = [
            "topic": topic,
            "event": "phx_join",
            "payload": [
                "config": [
                    "broadcast": ["ack": false, "self": false],
                    "presence": ["key": ""],
                    "postgres_changes": [[
                        "event": "*",
                        "schema": "public",
                        "table": "messages",
                        "filter": "conversation_id=eq.\(conversationID.uuidString.lowercased())"
                    ]]
                ],
                "access_token": accessToken
            ],
            "ref": "1"
        ]
        let data = try JSONSerialization.data(withJSONObject: join)
        socket.send(.data(data)) { _ in }

        listenTask = Task {
            while !Task.isCancelled {
                do {
                    let message = try await socket.receive()
                    let data: Data
                    switch message {
                    case .data(let incoming): data = incoming
                    case .string(let string): data = Data(string.utf8)
                    @unknown default: continue
                    }
                    if let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let event = object["event"] as? String,
                       event == "postgres_changes" {
                        await onChange()
                    }
                } catch {
                    break
                }
            }
        }
    }

    func disconnect() {
        listenTask?.cancel()
        listenTask = nil
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }
}
