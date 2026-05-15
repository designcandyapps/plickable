//
//  ConfigManager.swift
//  Kwell
//
//  Created by Hitesh Rupani on 06/09/25.
//

import Foundation

struct ConfigDataModel: Decodable {
    let subscriptionId: [String]?
    let currentAppVersion: String?
    let isCriticalVersion: Bool?
}

final class ConfigManager: ObservableObject {
    @Published var isOutdated: Bool = false
    @Published var availableProducts: [String] = []
    
    func fetchData() async {
        let endpoint = "app-config/"
        
        guard let url = URL(string: AppConstants.baseURL.current + endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let response = try await NetworkManager.downloadData(fromURL: request)
            let decodedResponse = try JSONDecoder().decode(ConfigDataModel.self, from: response)
            
            await MainActor.run {
                checkIfOutdated(latestVersion: decodedResponse.currentAppVersion ?? "",
                                isCritical: decodedResponse.isCriticalVersion ?? false)
                availableProducts = decodedResponse.subscriptionId ?? []
            }
        } catch {
            print("error fetching config: \(error)")
            return
        }
    }
    
    @MainActor
    private func checkIfOutdated(latestVersion: String, isCritical: Bool = false) {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print("currentVersion: ", currentVersion)
        
        let result = currentVersion.compare(latestVersion, options: .numeric)
        if result == .orderedAscending, isCritical {
            isOutdated = true
        } else {
            isOutdated = false
        }
    }
}
