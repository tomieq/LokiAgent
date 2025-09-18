import Foundation
import Combine

public enum LokiAgentError: Error {
    case uploadFailed
}

public enum LokiAutoUploadStrategy {
    case never
    case over(UInt)
}

public class LokiAgent {
    let lokiURL: URL
    let app: String
    public var autoUploadStrategy: LokiAutoUploadStrategy = .never
    private var messages = ThreadSafeList<LogEntry>()
    
    public init(app: String, lokiURL: URL) {
        self.app = app
        self.lokiURL = lokiURL
        
        Task {
            let publisher = Timer.publish(every: 10, on: .main, in: .default)
                .autoconnect()
            for await _ in publisher.values {
                try? await self.upload()
            }
        }
    }
    
    public func log(_ message: LogEntry) {
        messages.append(message)
        switch autoUploadStrategy {
        case .never:
            return
        case .over(let count):
            if messages.count > count {
                Task {
                    try? await upload()
                }
            }
        }
    }
    
    public func upload() async throws {
        let logs = self.messages.elements
        guard logs.count > 0 else {
            return
        }
        messages.remove(logs)
        Task {
            let dto = LokiPushDto(streams: [
                LokiStreamDto(app: app,
                              values: logs.map{ $0.dto })
            ])
            var request = URLRequest(url: lokiURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpReseponse = response as? HTTPURLResponse, httpReseponse.statusCode == 204 else {
                print("Resonse: \(response.debugDescription)")
                self.messages.append(logs)
                throw LokiAgentError.uploadFailed
            }
        }
    }
}
