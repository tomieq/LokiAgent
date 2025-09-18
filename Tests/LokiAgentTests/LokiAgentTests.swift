import Testing
import Foundation
@testable import LokiAgent

@Test func example() async throws {
    let log = LogEntry(Date(), "[Foundation] Traefik \(Int.random(in: 0...300))", level: .debug, tags: [
        "traceID": "1864239847"
    ])
    
    let lokiURL = URL(string: "http://localhost:3100/loki/api/v1/push")!
    
    let agent = LokiAgent(app: "iOS", lokiURL: lokiURL)
    agent.autoUploadStrategy = .never
    agent.log(log)
    try await agent.upload()

@Test func retry() async throws {
    class CustomUploader: Uploader {
        var result = true
        var lastDto: LokiPushDto?
        func upload(dto: LokiPushDto) async throws -> Bool {
            lastDto = dto
            return result
        }
    }

    let uploader = CustomUploader()
    let agent = LokiAgent(app: "iOS", uploader: uploader)
    agent.autoUploadStrategy = .never
    
    
    uploader.result = false
    
    let log = LogEntry(Date(), "[Foundation] Traefik \(Int.random(in: 0...300))", level: .debug, tags: [
        "traceID": "1864239847"
    ])
    
    agent.log(log)
    try? await agent.upload()
    #expect(uploader.lastDto?.streams.first?.values.count == 1)
    uploader.result = true
    
    
    agent.log(log)
    agent.log(log)
    
    try? await agent.upload()
    #expect(uploader.lastDto?.streams.first?.values.count == 3)
    
    
    agent.log(log)
    try? await agent.upload()
    #expect(uploader.lastDto?.streams.first?.values.count == 1)
}
