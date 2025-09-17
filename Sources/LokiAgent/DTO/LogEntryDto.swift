//
//  LogEntryDto.swift
//  LokiAgent
// 
//  Created by: tomieq on 17/09/2025
//

import Foundation

struct LogEntryDto {
    let time: Date
    let message: String
    let tags: [String: String]?
}

extension LogEntryDto: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        let nanos = Int64(time.timeIntervalSince1970 * 1_000_000_000)
        try container.encode(String(nanos))
        try container.encode(message)
        if let tags {
            try container.encode(tags)
        }
    }
}
