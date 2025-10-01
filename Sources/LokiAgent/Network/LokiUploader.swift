//
//  LokiUploader.swift
//  LokiAgent
// 
//  Created by: tomieq on 18/09/2025
//
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class LokiUploader: Uploader {
    let serverURL: URL
    
    init(serverURL: URL) {
        self.serverURL = serverURL
    }

    func upload(dto: LokiPushDto) async throws -> Bool {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(dto)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpReseponse = response as? HTTPURLResponse, httpReseponse.statusCode == 204 else {
            return false
        }
        return true
    }
}


