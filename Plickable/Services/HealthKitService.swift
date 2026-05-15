//
//  HealthKitManager.swift
//  Kwell
//
//  Created by Hitesh Rupani on 28/11/24.
//

import SwiftUI
import HealthKit

final class HealthKitService {
    private let healthStore = HKHealthStore()
    
    private let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    private let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    private let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
    private let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
    
    @AppStorage("healthKitAuthRequested") var healthKitAuthRequested: Bool = false
    
    func getBiofeedbackScore(completion: @escaping (Double, Error?) -> Void) {
        if healthKitAuthRequested {
            self.calculateBiofeedbackScore { score in
                completion(score, nil)
            }
        } else {
            requestAuth { success, error in
                if success {
                    self.healthKitAuthRequested = true
                    self.calculateBiofeedbackScore { score in
                        completion(score, nil)
                    }
                } else if let error = error {
                    completion(0.0, error)
                }
            }
        }
    }
    
    func addMindfulSession(duration: TimeInterval) {
        if healthKitAuthRequested {
            let endDate = Date()
            let startDate = endDate - duration
            
            let mindfulSession = HKCategorySample(
                type: mindfulType,
                value: HKCategoryValue.notApplicable.rawValue,
                start: startDate,
                end: endDate
            )
            
            healthStore.save(mindfulSession) { success, error in
                guard let error else { return }
                print("Error saving mindful session: \(error)")
            }
        } else {
            requestAuth { success, error in
                if success {
                    self.healthKitAuthRequested = true
                    self.addMindfulSession(duration: duration)
                }
                
                guard let error else { return }
                print("Error requesting auth: \(error)")
            }
        }
    }
    
    private func requestAuth(completion: @escaping (Bool, Error?) -> Void) {
        let typesToRead: Set<HKObjectType> = [hrvType, heartRateType, mindfulType, respiratoryRateType]
        let typesToShare: Set<HKSampleType> = [mindfulType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: completion)
    }
}

extension HealthKitService {
    private func calculateBiofeedbackScore(completion: @escaping (Double) -> Void) {
        var hrv: Double?
        var heartRate: Double?
        var mindfulness: Double?
        var respiratoryRate: Double?
        
        let group = DispatchGroup()
        
        group.enter()
        fetchHRV { value in
            hrv = value
            group.leave()
        }
        
        group.enter()
        fetchHeartRate { value in
            heartRate = value
            group.leave()
        }
        
        group.enter()
        fetchMindfulMinutes { value in
            mindfulness = value
            group.leave()
        }
        
        group.enter()
        fetchRespiratoryRate { value in
            respiratoryRate = value
            group.leave()
        }
        
        group.notify(queue: .main) {
            // Default scores and dynamic weights
            var totalWeight: Double = 0
            var biofeedbackScore: Double = 0
            
            if let hrv = hrv {
                let hrvWeight = 0.25
                let normalizedHRV = min(max(hrv / 100, 0), 1) // HRV typically ranges from 0-100 ms
                biofeedbackScore += normalizedHRV * hrvWeight
                totalWeight += hrvWeight
            }
            
            if let heartRate = heartRate {
                let heartRateWeight = 0.25
                let normalizedHeartRate = min(max((100 - heartRate) / 100, 0), 1) // Assuming lower HR is better
                biofeedbackScore += normalizedHeartRate * heartRateWeight
                totalWeight += heartRateWeight
            }
            
            if let mindfulness = mindfulness {
                let mindfulWeight = 0.25
                let normalizedMindfulness = min(max(mindfulness / 500, 0), 1) // Assuming 500 min/day is optimal
                biofeedbackScore += normalizedMindfulness * mindfulWeight
                totalWeight += mindfulWeight
            }
            
            if let respiratoryRate = respiratoryRate {
                let respiratoryWeight = 0.25
                let normalizedRespiratory = min(max((18 - respiratoryRate) / 18, 0), 1) // Assuming 18 breaths/min is a threshold
                biofeedbackScore += normalizedRespiratory * respiratoryWeight
                totalWeight += respiratoryWeight
            }
            
            // Normalize score to 0–100
            if totalWeight > 0 {
                completion((biofeedbackScore / totalWeight) * 100)
            } else {
                completion(0) // No data available
            }
        }
    }

    // Fetching HRV Data
    private func fetchHRV(completion: @escaping (Double?) -> Void) {
        let query = HKStatisticsQuery(quantityType: hrvType, quantitySamplePredicate: nil, options: .discreteAverage) { _, result, _ in
            guard let result = result, let avgHRV = result.averageQuantity()?.doubleValue(for: HKUnit(from: "ms")) else {
                completion(nil)
                return
            }
            completion(avgHRV)
        }
        healthStore.execute(query)
    }
    
    // Fetch Heart Rate Data
    private func fetchHeartRate(completion: @escaping (Double?) -> Void) {
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: nil, options: .discreteAverage) { _, result, _ in
            guard let result = result, let avgHR = result.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) else {
                completion(nil)
                return
            }
            completion(avgHR)
        }
        healthStore.execute(query)
    }
    
    // Fetching today's meditation duration
    private func fetchMindfulMinutes(completion: @escaping (Double?) -> Void) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: today, end: Date(), options: [])
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: 0, sortDescriptors: nil) { _, results, _ in
            guard let results = results as? [HKCategorySample] else {
                completion(nil)
                return
            }
            let totalMindfulness = results.reduce(0.0) { sum, sample in
                return sum + sample.endDate.timeIntervalSince(sample.startDate) / 60 // Convert seconds to minutes
            }
            completion(totalMindfulness)
        }
        healthStore.execute(query)
    }
    
    // Fetching average respiratory rate
    private func fetchRespiratoryRate(completion: @escaping (Double?) -> Void) {
        let query = HKStatisticsQuery(quantityType: respiratoryRateType, quantitySamplePredicate: nil, options: .discreteAverage) { _, result, _ in
            guard let result = result, let avgRate = result.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) else {
                completion(nil)
                return
            }
            completion(avgRate)
        }
        healthStore.execute(query)
    }
}
