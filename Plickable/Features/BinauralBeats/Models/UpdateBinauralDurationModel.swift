//
//  API.swift
//  Kwell
//
//  Created by Hitesh Rupani on 10/10/24.
//

import Foundation

// MARK: - update-binaural-duration API
struct UpdateBinauralDurationRequest: Codable {
    let id: Int
    let binauralDuration: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case id
        case binauralDuration = "binaural_duration"
    }
}

struct UpdateBinauralDurationResponse: Codable {
    let message: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case message
        case id = "ID"
    }
}
