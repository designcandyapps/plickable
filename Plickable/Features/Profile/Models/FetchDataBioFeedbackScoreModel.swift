//
//  fetchDataBioFeedbackScoreModel.swift
//  Kwell
//
//  Created by Hitesh Rupani on 16/01/25.
//

import Foundation

// MARK: - Response
struct FetchDataBFSResponse: Codable {
    let bioFeedbackData: [BioFeedbackData]?
    
    enum CodingKeys: String, CodingKey {
        case bioFeedbackData = "Bio_Feedback_Data"
    }
}

struct BioFeedbackData: Codable {
    let bioFeedbackScore: Double?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case bioFeedbackScore = "Bio_Feedback_Score"
        case timestamp = "Date with Timestamp"
    }
}
