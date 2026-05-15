//
//  API.swift
//  Kwell
//
//  Created by Hitesh Rupani on 10/10/24.
//

import Foundation

// MARK: - Response
struct UploadToSpacesResponse: Codable {
    let message: String
    let id: Int
    let fileURL: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case id = "ID"
        case fileURL = "file_url"
    }
}
