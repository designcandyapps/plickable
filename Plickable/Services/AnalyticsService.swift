//
//  AnalyticsService.swift
//  Kwell
//
//  Created by Hitesh Rupani on 22/01/25.
//

import Foundation

final class AnalyticsService {
    // MARK: - /fetch-data/
    func apiFetchAnalytics(numberOfRecords records: Int) async -> [AnalyticsData] {
        let endpoint = "fetch-data/"
        guard let url = URL(string: AppConstants.baseURL.current + endpoint) else { return [] }
        
        // request body
        let fetchRequest = FetchDataRequest(numberOfRecords: records, deviceID: Device.id)
        guard let httpBody = try? JSONEncoder().encode(fetchRequest) else { return [] }
        
        // configuring request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = httpBody
        
        do {
            let response = try await NetworkManager.downloadData(fromURL: request)
            let decodedResponse = try JSONDecoder().decode(FetchDataResponse.self, from: response)
            
            guard let analytics = decodedResponse.analytics else { return [] }
            return analytics
        } catch {
            print("error fetching analytics:", error.localizedDescription)
            return []
        }
    }
}
