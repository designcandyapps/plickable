//
//  DashboardVM.swift
//  Kwell
//
//  Created by Hitesh Rupani on 24/01/25.
//

import AVFoundation
import SwiftUI

enum DashboardViewState {
    case idle
    case recording
    case processing
    case completed
    case binauralBeats
    
    var buttonTitle: String {
        switch self {
        case .idle, .binauralBeats:
            "Start Recording"
        case .recording:
            "Stop Recording"
        case .processing:
//            "Play Binaural Beats"
            "Record Again"
        case .completed:
//            "Play Binaural Beats"
            "Record Again"
        }
    }
}

@MainActor
class DashboardVM: ObservableObject {
    private let detectService = DetectService()
    private let healthKitService = HealthKitService()
    private let audioRecordingManager = AudioRecordingManager()
    
    private enum Constants {
        static let recordingDuration: Float = 5
        static let minimumRecordingDuration: Float = recordingDuration - 2
    }
    
    @Published var state: DashboardViewState = .idle
    @Published var timeRemaining: Float = Constants.recordingDuration
    @Published var detectedResult: DetectResponse?
    @Published var beatsPlayed: Bool = false

    var canStopRecording: Bool {
        timeRemaining <= Constants.minimumRecordingDuration
    }
    
    func startRecording() {
        FIRAnalytics.logEvent(event: .startRecording)
        FacebookEvents.logEvent(event: .startRecording)
        
        reset()
        state = .recording
        
        audioRecordingManager.startAudioRecording()
        TimerManager.startTimer(duration: Constants.recordingDuration) {[weak self] time in
            self?.timeRemaining = time
        } onFinish: { [weak self] in
            Task { @MainActor in
                await self?.stopRecording()
            }
        }
    }
    
    func stopRecording() async {
        TimerManager.stop()
        audioRecordingManager.stopAudioRecording()
        state = .processing
        timeRemaining = Constants.recordingDuration // reset timer
        
        if let detectResponse = await detectService.apiUploadAudio(audioFileURL: audioRecordingManager.audioFileURL?.absoluteString ?? "") {
            detectedResult = detectResponse
            state = .completed
            
            healthKitService.addMindfulSession(duration: TimeInterval(abs(detectResponse.result.maxEmotion.points * 600 + 5)))
            
            NotificationCenter.default.post(name: .receivedDetectedEmotion, object: nil)
        } else {
            print("Error processing recording.")
            reset()
        }
    }
    
    func reset() {
        state = .idle
        detectedResult = nil
        beatsPlayed = false
        timeRemaining = Constants.recordingDuration
    }
    
}
