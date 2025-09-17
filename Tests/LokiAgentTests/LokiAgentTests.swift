import Testing
import Foundation
@testable import LokiAgent

@Test func example() async throws {
    let log = LogEntry(Date(), "[Foundation] Attention!", level: .warning, tags: [
        "traceID": "1864239847"
    ])
    
    let lokiURL = URL(string: "http://localhost:3100/loki/api/v1/push")!
    
    let agent = LokiAgent(app: "iOS", lokiURL: lokiURL)
    agent.autoUploadStrategy = .never
    agent.log(log)
    try await agent.upload()
}
