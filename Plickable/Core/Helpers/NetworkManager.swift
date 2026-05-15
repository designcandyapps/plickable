//
//  NetworkManager.swift
//  Kwell
//
//  Created by Hitesh Rupani on 15/01/25.
//

import Foundation

final class NetworkManager {
    static func downloadData(fromURL url: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
