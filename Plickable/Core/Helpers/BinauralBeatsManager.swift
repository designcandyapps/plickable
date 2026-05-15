//
//  BinauralBeatsManager.swift
//  Kwell
//
//  Created by Hitesh Rupani on 25/01/25.
//

import Foundation
import AVFoundation

class BinauralBeatsManager {
    private let audioEngine = AVAudioEngine()
    private let leftOscillator = AVAudioPlayerNode()
    private let rightOscillator = AVAudioPlayerNode()
    
    func startBinauralBeats(baseFrequencyValue: Double, beatFrequencyValue: Double) {
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
            } catch {
                print("Audio engine failed to start: \(error.localizedDescription)")
                return
            }
        }
        
        updateFrequencies(baseFrequencyValue: baseFrequencyValue, beatFrequencyValue: beatFrequencyValue)
        leftOscillator.play()
        rightOscillator.play()
    }
    
    func stopBinauralBeats() {
        leftOscillator.stop()
        rightOscillator.stop()
    }
    
    func setupAudioEngine() {
        audioEngine.attach(leftOscillator)
        audioEngine.attach(rightOscillator)
        
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.connect(leftOscillator, to: mainMixer, format: nil)
        audioEngine.connect(rightOscillator, to: mainMixer, format: nil)
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine failed to start: \(error.localizedDescription)")
        }
    }
    
    private func updateFrequencies(baseFrequencyValue: Double, beatFrequencyValue: Double) {
        
        let leftFrequency = baseFrequencyValue - (beatFrequencyValue / 2)
        let rightFrequency = baseFrequencyValue + (beatFrequencyValue / 2)
        
        // Adjust the playback rate of the oscillators based on the frequencies
        leftOscillator.scheduleBuffer(generateSineWaveBuffer(frequency: leftFrequency), at: nil, options: .loops)
        rightOscillator.scheduleBuffer(generateSineWaveBuffer(frequency: rightFrequency), at: nil, options: .loops)
    }
    
    private func generateSineWaveBuffer(frequency: Double) -> AVAudioPCMBuffer {
        let sampleRate: Double = 44100
        let duration: Double = 2.0 // Increased duration for a smoother loop
        let frameCount = UInt32(sampleRate * duration)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioEngine.outputNode.outputFormat(forBus: 0), frameCapacity: frameCount)!
        buffer.frameLength = frameCount
        
        let amplitude: Float = 1.0
        let twoPi = Float.pi * 2
        let thetaIncrement = twoPi * Float(frequency) / Float(sampleRate)
        
        var theta: Float = 0
        for frame in 0..<Int(frameCount) {
            let sample = sin(theta) * amplitude
            buffer.floatChannelData?.pointee[frame] = sample
            theta += thetaIncrement
            
            // Ensure continuity by wrapping theta within 0 to 2*PI range
            if theta > twoPi { theta -= twoPi }
        }
        
        return buffer
    }
}
