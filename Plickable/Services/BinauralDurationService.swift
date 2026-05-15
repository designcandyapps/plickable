//
//  BinauralDurationService.swift
//  Kwell
//
//  Created by Hitesh Rupani on 24/01/25.
//

import Foundation

final class BinauralDurationService {
    // MARK: - /update-binaural-duration/
    func apiUpdateBinauralDuration(id: Int, duration: TimeInterval) async {
        let endpoint = "update-binaural-duration/"
        guard let url = URL(string: AppConstants.baseURL.current + endpoint) else { return }
        
        // request body
        let updateRequest = UpdateBinauralDurationRequest(id: id, binauralDuration: duration)
        guard let httpBody = try? JSONEncoder().encode(updateRequest) else { return }
        
        // configuring request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = httpBody
        
        do {
            let response = try await NetworkManager.downloadData(fromURL: request)
            let decodedResponse = try JSONDecoder().decode(UpdateBinauralDurationResponse.self, from: response)
            print(decodedResponse)
        } catch {
            print("error updating binaural duration:\n", error)
        }
    }
}
