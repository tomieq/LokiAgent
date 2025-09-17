//
//  LogEntry.swift
//  LokiAgent
// 
//  Created by: tomieq on 17/09/2025
//

import Foundation


public struct LogEntry {
    public let date: Date
    public let message: String
    public let tags: [String: CustomStringConvertible]?
    
    public init(_ date: Date, _ message: String, level: LogLevel? = nil, tags: [String : CustomStringConvertible]? = nil) {
        self.date = date
        self.message = message
        if let level {
            var tags = tags ?? [:]
            tags["level"] = level.rawValue
            self.tags = tags
        } else {
            self.tags = tags
        }
    }
}

extension LogEntry {
    var dto: LogEntryDto {
        LogEntryDto(time: date, message: message, tags: tags?.mapValues{ $0.description })
    }
}
