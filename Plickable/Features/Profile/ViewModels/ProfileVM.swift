//
//  ProfileVM.swift
//  Kwell
//
//  Created by Hitesh Rupani on 22/11/24.
//

import Foundation
import HealthKit
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {
    // MARK: - Services
    let healthKitService = HealthKitService()
    let bfsService = BioFeedbackScoreService()
    let analyticsService = AnalyticsService()
    
    // MARK: - Properties
//    @Published var showHealthKitAuthAlert: Bool = false {
//        didSet{
//            print("Fetched biofeedback score")
//            fetchBioFeedbackScore()
//        }
//    }
    @Published var bioFeedbackScore: Double = 0.0
    @Published private var bfsData: [BioFeedbackData] = []
    @Published var improvementPercentage: Double = 0.0
    
//    init() {
//        showHealthKitAuthAlert = !healthKitService.healthKitAuthRequested
//    }
    
    // MARK: - Load BFS Data, Improvement Percentage and Upload BFS (if needed)
    func loadData() async {
//        fetchHealthKitBFS()
        await fetchBFS()
        
        bfsData = await bfsService.apiFetchDataBioFeedbackScore()
        improvementPercentage = getImprovementPercentage()
        
        // updating current score if different
        await updateBioFeedbackScore()
    }
    
    func fetchBFS() async {
        let analyticsScore = await fetchAnalyticsBFS()
        
        fetchHealthKitBFS { healthKitScore in
            self.bioFeedbackScore = (healthKitScore + analyticsScore) / 2
        }
    }
    
    // MARK: - Fetch BFS from Health Kit
    func fetchHealthKitBFS(completion: @escaping (Double) -> Void) {
//        if !showHealthKitAuthAlert {
            healthKitService.getBiofeedbackScore { score, error in
//                self.bioFeedbackScore = score
                completion(score)
                if let error {
                    print("Error fetching biofeedback score: \(error)")
                }
            }
//        }
    }
    
    // MARK: Fetch BFS from Analytics
    private func fetchAnalyticsBFS() async -> Double {
        let data = await analyticsService.apiFetchAnalytics(numberOfRecords: 5)
        
        // Calculating the average score from the emotions' score in the analytics data
        let allScores: [Double] = data.compactMap { data in
            if let score = data.emotion?.score {
                return score / 0.74 // Normalizing the score to a 0-1 range based on the max score of 0.74
            }
            return nil
        }
        
        // Calculating the average score
        var averageScore: Double = 0
        if !allScores.isEmpty {
            averageScore = allScores.reduce(0, +) / Double(allScores.count)
        }
        
        // Setting the bioFeedbackScore to the average score updated to a percentage
        return averageScore * 100
    }
    
    //  MARK: Update BFS
    private func updateBioFeedbackScore() async {
        // To save unnecessary calls
        if let latestData = bfsData.first {
            let score = latestData.bioFeedbackScore
            let date = DateMethods.convertToLocalTimeZone(from: latestData.timestamp ?? "", type: .ddMMyyyy) ?? ""
            let currentDate = DateMethods.convertToLocalTimeZone(from: DateMethods.dateInISOFormat(), type: .ddMMyyyy) ?? "" // to match date formats
            
            if bioFeedbackScore != score || date != currentDate {
                await self.bfsService.apiUpdateBioFeedbackScore(bioFeedbackScore: bioFeedbackScore)
            }
        } else {
            await self.bfsService.apiUpdateBioFeedbackScore(bioFeedbackScore: bioFeedbackScore)
        }
    }
    
    // MARK: - Improvement Percentage
    private func getImprovementPercentage() -> Double {
        guard bfsData.count > 0 else { return 0 }
        
        let current = bioFeedbackScore
        
        switch bfsData.count {
        case 1:
            let prev = bfsData[0]
            if let prevScore = prev.bioFeedbackScore {
                return calculateImprovementPercentage(before: prevScore, now: current)
            } else {
                return 0
            }
        case 2:
            let lastRecord = bfsData[0]
            let secondLastRecord = bfsData[1]
            
            if lastRecord.bioFeedbackScore == current, let before = secondLastRecord.bioFeedbackScore {
                return calculateImprovementPercentage(before: before, now: current)
            } else if let before = lastRecord.bioFeedbackScore {
                return calculateImprovementPercentage(before: before, now: current)
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    private func calculateImprovementPercentage(before prev: Double, now current: Double) -> Double {
        guard prev != 0 else { return 0 }
        let improvementPercentage = (current - prev) / prev
        return improvementPercentage
    }
}
