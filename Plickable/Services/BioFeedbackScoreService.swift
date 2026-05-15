//
//  FetchDataBFSService.swift
//  Kwell
//
//  Created by Hitesh Rupani on 16/01/25.
//

import Foundation
import UIKit

final class BioFeedbackScoreService {
    // MARK: - /fetch-data-bioFeedbackScore/
    func apiFetchDataBioFeedbackScore(records: Int = 2) async -> [BioFeedbackData] {
        let endpoint = "fetch-data-bioFeedbackScore/"
        guard let url = URL(string: "\(AppConstants.baseURL.current + endpoint)?number_of_records=\(records)&device_id=\(Device.id)") else { return [] }
        
        // configuring request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let data = try await NetworkManager.downloadData(fromURL: request)
            let response = try JSONDecoder().decode(FetchDataBFSResponse.self, from: data)
            if let decodedData = response.bioFeedbackData {
                return decodedData
            } else {
                print("error decoding fetched BFS data")
                return []
            }
        } catch {
            print("Error fetching biofeedback score data:", error.localizedDescription)
            return []
        }
    }
    
    // MARK: - /update-bio-feedback-score/
    func apiUpdateBioFeedbackScore(bioFeedbackScore score: Double) async {
        let endpoint = "update-bio-feedback-score/"
        guard let url = URL(string: AppConstants.baseURL.current + endpoint) else {return}
        
        // date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let date = dateFormatter.string(from: currentDate)
        
        // request body
        let updateRequest = UpdateBFSRequest(date: date, deviceId: Device.id, bioFeedbackScore: score)
        guard let httpBody = try? JSONEncoder().encode(updateRequest) else {return}
        
        // configuring request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = httpBody
        
        do {
            let data = try await NetworkManager.downloadData(fromURL: request)
            let response = try JSONDecoder().decode(UpdateBFSResponse.self, from: data)
            print(response)
        } catch {
            print("Error updating bio feedback score:", error.localizedDescription)
        }
    }
}
