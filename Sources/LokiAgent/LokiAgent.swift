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
    let app: String
    public var autoUploadStrategy: LokiAutoUploadStrategy = .never
    private var messages = ThreadSafeList<LogEntry>()
    private let uploader: Uploader
    
    init (app: String, uploader: Uploader) {
        self.app = app
        self.uploader = uploader
        Task {
            let publisher = Timer.publish(every: 10, on: .main, in: .default)
                .autoconnect()
            for await _ in publisher.values {
                try? await self.upload()
            }
        }
    }
    
    public convenience init(app: String, lokiURL: URL) {
        self.init(app: app, uploader: LokiUploader(serverURL: lokiURL))
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
        print(logs)
        messages.remove(logs)
        let dto = LokiPushDto(streams: [
            LokiStreamDto(app: app,
                          values: logs.map{ $0.dto })
        ])
        let success = try await uploader.upload(dto: dto)
        if !success {
            self.messages.append(logs)
            throw LokiAgentError.uploadFailed
        }
    }
}
