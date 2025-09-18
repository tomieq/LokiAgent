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
    
    public init(_ date: Date, _ message: String, level: LokiLogLevel? = nil, tags: [String : CustomStringConvertible]? = nil) {
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

extension LogEntry: Equatable {
    public static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
        guard lhs.date == rhs.date, lhs.message == rhs.message else {
            return false
        }
        guard lhs.tags?.count == rhs.tags?.count else {
            return false
        }
        guard let lhsTags = lhs.tags, let rhsTags = rhs.tags else {
            return true
        }
        for (key, lhsValue) in lhsTags {
            guard let rhsValue = rhsTags[key], "\(lhsValue)" == "\(rhsValue)" else {
                return false
            }
        }
        return true
    }
}
extension LogEntry {
    var dto: LogEntryDto {
        LogEntryDto(time: date, message: message, tags: tags?.mapValues{ $0.description })
    }
}
