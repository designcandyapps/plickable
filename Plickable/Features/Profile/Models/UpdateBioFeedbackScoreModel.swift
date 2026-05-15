//
//  UpdateBioFeedbackScoreModel.swift
//  Kwell
//
//  Created by Hitesh Rupani on 12/01/25.
//

import Foundation

struct UpdateBFSRequest: Codable {
    let date: String?
    let deviceId: String?
    let bioFeedbackScore: Double?
    
    enum CodingKeys: String, CodingKey {
        case date
        case deviceId = "device_id"
        case bioFeedbackScore = "bio_feedback_score"
    }
}

struct UpdateBFSResponse: Codable {
    let error: String?
    let message: String?
    let id: Int?
    let date: String?
    let deviceID: String?
    let bioFeedbackScore: Double?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case id = "ID"
        case date = "Date"
        case deviceID = "Device ID"
        case bioFeedbackScore = "Bio Feedback Score"
    }
}
