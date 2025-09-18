//
//  Uploader.swift
//  LokiAgent
// 
//  Created by: tomieq on 18/09/2025
//
import Foundation

protocol Uploader {
    func upload(dto: LokiPushDto) async throws -> Bool
}
