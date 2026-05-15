//
//  AppConstants.swift
//  Plickable
//
//  Created by Hitesh Rupani on 20/05/25.
//

import SwiftUI

final class AppConstants {
    enum baseURL: String {
        case debug = "https://devapi.plickable.com/api/"
        case release = "https://api.plickable.com/api/"
        
        static var current: String {
            #if DEBUG
            return debug.rawValue
            #else
            return release.rawValue
            #endif
        }
    }
    
    enum analyticsEvent: String {
        case startRecording = "start_recording"
        case openStats = "open_stats"
        case openProfile = "open_profile"
        case recordAgain = "record_again"
//        case openHealthKit = "open_healthkit"
//        case playBeats = "play_beats"
//        case stopBeats = "stop_beats"
    }
}
