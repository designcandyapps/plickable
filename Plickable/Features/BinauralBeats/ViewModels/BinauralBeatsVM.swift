//
//  BinauralBeatsVM.swift
//  Kwell
//
//  Created by Hitesh Rupani on 12/11/24.
//

import Foundation
import AVFoundation

class BinauralBeatsVM: ObservableObject {
    let binauralDurationService = BinauralDurationService()
    let binauralBeatsManager = BinauralBeatsManager()
    
    @Published var duration: TimeInterval = 0
    private var timer: Timer?
    
    let baseFrequencyValue: Double = 440
    
    func startPlaying(beatFrequencyValue: Double) {
        binauralBeatsManager.setupAudioEngine()
        binauralBeatsManager.startBinauralBeats(baseFrequencyValue: baseFrequencyValue, beatFrequencyValue: beatFrequencyValue)
        TimerManager.startStopWatch(timeInterval: 0.01) { [weak self] timeInterval in
            self?.duration = timeInterval
        }
    }
    
    func stopPlaying(id: Int) async {
        binauralBeatsManager.stopBinauralBeats()
        TimerManager.stop()
        await binauralDurationService.apiUpdateBinauralDuration(id: id, duration: (duration * 100).rounded() / 100)
    }
}
