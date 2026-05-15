//
//  API.swift
//  Kwell
//
//  Created by Hitesh Rupani on 10/10/24.
//


// MARK: - Request
struct FetchDataRequest: Codable {
    let numberOfRecords: Int
    let deviceID: String
    
    enum CodingKeys: String, CodingKey {
        case numberOfRecords = "number_of_records"
        case deviceID = "device_id"
    }
}

// MARK: - Response
struct FetchDataResponse: Codable {
    let analytics: [AnalyticsData]?
    
    enum CodingKeys: String, CodingKey {
        case analytics = "Analytics"
    }
}

// MARK: - Datum
struct AnalyticsData: Codable, Hashable {
    let timestamp: String
    let binauralDuration: Double?
    var emotion: Emotion?
    
    var day: String {
        DateMethods.convertToLocalTimeZone(from: timestamp, type: .dd) ?? ""
    }
    
    var month: String {
        DateMethods.convertToLocalTimeZone(from: timestamp, type: .MMM) ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "Date with Timestamp"
        case binauralDuration = "Binaural Duration"
        case emotion = "Emotion"
    }
}

enum Emotion: String, Codable {
    case sadness
    case anger
    case approval
    case neutral
    case optimism
    case joy
    
    var score: Double {
        switch self {
        case .sadness: 0.25
        case .anger: 0.35
        case .approval: 0.45
        case .neutral: 0.5
        case .optimism: 0.65
        case .joy: 0.74
        }
    }
    
    var height: Double {
        switch self {
        case .sadness: 3
        case .anger: 8
        case .approval: 16
        case .neutral: 23
        case .optimism: 31
        case .joy: 34
        }
    }
    
    var points: Int {
        switch self {
        case .sadness: -70
        case .anger: -50
        case .approval: -20
        case .neutral: 0
        case .optimism: 20
        case .joy: 50
        }
    }
    
    var beatFrequency: Double {
        switch self {
        case .sadness: 4
        case .approval: 8
        case .neutral: 12
        case .optimism: 13
        case .joy : 74
        default: 0
        }
    }
}
