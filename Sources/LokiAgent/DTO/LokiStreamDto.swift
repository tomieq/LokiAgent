//
//  LokiStreamDto.swift
//  LokiAgent
// 
//  Created by: tomieq on 17/09/2025
//

import Foundation

struct LokiStreamDto: Codable {

    let stream: [String: String]
    let values: [LogEntryDto]
    
    init(app: String, tags: [String: String] = [:], values: [LogEntryDto]) {
        var tags = tags
        tags["app"] = app
        self.stream = tags
        self.values = values
    }
}
