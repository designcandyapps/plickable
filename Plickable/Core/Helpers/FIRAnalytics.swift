//
//  FIRAnalytics.swift
//  Kwell
//
//  Created by Hitesh Rupani on 20/05/25.
//

import FirebaseAnalytics

final class FIRAnalytics {
    class func logEvent(event: AppConstants.analyticsEvent, parameters: [String: Any]? = nil) {
        var params: [String: Any] = ["device_identifier" : Device.id]
        parameters?.forEach { params[$0] = $1 }
        
        Analytics.logEvent(event.rawValue, parameters: params)
    }
}
