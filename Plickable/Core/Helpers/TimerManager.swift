//
//  TimerManager.swift
//  Kwell
//
//  Created by Hitesh Rupani on 24/01/25.
//

import Foundation

class TimerManager {
    static var timer: Timer?
    
    static func startTimer(duration: Float, timeInterval: Float = 1, onTick: ((Float) -> Void)?, onFinish: @escaping () -> Void) {
        var timeRemaining = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= timeInterval
            onTick?(timeRemaining)
            
            if timeRemaining <= 0 {
                onFinish()
                self.stop()
            }
        }
    }
    
    static func startStopWatch(timeInterval: TimeInterval = 1, onTick: ((TimeInterval) -> Void)?) {
        var timeElapsed: TimeInterval = 0
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            timeElapsed += timeInterval
            onTick?(timeElapsed)
        }
    }
    
    static func stop() {
        timer?.invalidate()
        timer = nil
    }
}
