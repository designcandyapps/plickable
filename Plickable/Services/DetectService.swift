//
//  DetectService.swift
//  Kwell
//
//  Created by Hitesh Rupani on 20/01/25.
//

import Foundation

final class DetectService {
    // MARK: - /upload-to-spaces/
    func apiUploadAudio(audioFileURL : String) async -> DetectResponse? {
        let endpoint = "upload-to-spaces/"
        guard let url = URL(string: AppConstants.baseURL.current + endpoint) else { return nil }

        guard let audioFile = URL(string: audioFileURL) else {
            print("Invalid audio file URL")
            return nil
        }
        
        do {
            let audioData = try Data(contentsOf: audioFile)
            
            // configuring request
            var request = URLRequest(url: url)
            let boundary = UUID().uuidString
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            var body = Data()
            
            // appending audio file
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioFile.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/x-m4a\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)
            
            // appending device ID
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"device_id\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(Device.id)\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            // sending request
            let data = try await NetworkManager.downloadData(fromURL: request)
            let response = try JSONDecoder().decode(UploadToSpacesResponse.self, from: data)
            print(response)
            
            // MARK: Calling detect API
            if let detectResponse = await self.apiDetect(id: response.id) {
                return detectResponse
            } else {
                return nil
            }
            
        } catch {
            print("Failed to read audio data:\n\(error)")
            return nil
        }
    }
    
    // MARK: - /detect/
    private func apiDetect(id: Int) async -> DetectResponse? {
        let endpoint = "detect/"
        guard let url = URL(string: AppConstants.baseURL.current + endpoint) else {
            return nil
        }
        
        let detectRequest = DetectRequest(id: id)
        guard let httpBody = try? JSONEncoder().encode(detectRequest) else { return nil
        }
        
        // configuring request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = httpBody
        
        do {
            let data = try await NetworkManager.downloadData(fromURL: request)
            return try JSONDecoder().decode(DetectResponse.self, from: data)
        } catch {
            print("Error fetching data from detect API:\n", error)
            return nil
        }
    }
}
