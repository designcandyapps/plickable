//
//  AppDelegate.swift
//  Plickable
//
//  Created by Hitesh Rupani on 20/05/25.
//

import FacebookCore
import FirebaseCore
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // for launch screen
        Thread.sleep(forTimeInterval: 1)
        
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.requestTracking()
        }
        
        // firebase
        FirebaseApp.configure()

        return true
    }
    
    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { (status) in
            switch status {
            case .authorized:
                Settings.shared.isAutoLogAppEventsEnabled = true
                Settings.shared.isAdvertiserTrackingEnabled = true
                Settings.shared.isAdvertiserIDCollectionEnabled = true
            case .denied:
                Settings.shared.isAutoLogAppEventsEnabled = false
                Settings.shared.isAdvertiserTrackingEnabled = false
                Settings.shared.isAdvertiserIDCollectionEnabled = false
            default:
                break
            }
        })
    }
}
