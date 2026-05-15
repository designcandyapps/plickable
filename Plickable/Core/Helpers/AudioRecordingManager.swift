//
//  AudioRecordingManager.swift
//  Kwell
//
//  Created by Hitesh Rupani on 20/01/25.
//

import Foundation
import AVFAudio

class AudioRecordingManager {
    var audioRecorder: AVAudioRecorder?
    var audioFileURL: URL?
    
    func startAudioRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioFileURL = getAudioFileURL() // Get file URL to save audio
            
            if let fileURL = audioFileURL {
                audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                audioRecorder?.record()
            }
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopAudioRecording() {
        audioRecorder?.stop()
        // MARK: audio file path
        print("Recording stopped. File saved at : \(audioFileURL?.absoluteString ?? "")")
    }
    
    // Helper function to get audio file URL
    func getAudioFileURL() -> URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "recording_\(UUID().uuidString).m4a"
        return documentsPath.appendingPathComponent(fileName)
    }
}
