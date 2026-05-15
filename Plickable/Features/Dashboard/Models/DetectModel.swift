//
//  API.swift
//  Kwell
//
//  Created by Hitesh Rupani on 10/10/24.
//

import Foundation

// MARK: - detect API
struct DetectRequest: Codable {
    let id: Int
}

struct DetectResponse: Codable {
    let result: Result
    let id: Int
}

struct Result: Codable {
    let text: String
    let maxEmotion: Emotion
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        case text
        case maxEmotion = "max_emotion"
        case score
    }
}
