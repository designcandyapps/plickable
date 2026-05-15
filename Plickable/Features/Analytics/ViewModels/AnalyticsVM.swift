//
//  AnalyticsVM.swift
//  Kwell
//
//  Created by Hitesh Rupani on 12/11/24.
//

import Foundation
import SwiftUICore

@MainActor
class AnalyticsVM: ObservableObject {
    private let analyticsService = AnalyticsService()
    
//    private let numberOfDays: Int = 30
    private let numberOfRecords: Int = 5
    
    @Published var analytics: [AnalyticsData] = []
//    @Published var mostPrevalentEmotion: (String, Int) = ("N/A", 0)
    
    func fetchAnalytics() async {
        let data = await analyticsService.apiFetchAnalytics(numberOfRecords: numberOfRecords)
        analytics = data.reversed()

//        mostPrevalentEmotion = getMostPrevalentEmotion()
    }
    
//    private func getMostPrevalentEmotion() -> (String, Int) {
//        var emotions: [String] = []
//        
//        for item in analytics {
//            if let emotion = item.emotion {
//                emotions.append(emotion)
//            }
//        }
//        
//        let emotion = emotions.max(by: { $0.count < $1.count })
//        let count = emotions.filter({ $0 == emotion! }).count
//        
//        return (emotion ?? "N/A", count)
//    }
}
