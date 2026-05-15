//
//  FacebookEvents.swift
//  Kwell
//
//  Created by Hitesh Rupani on 07/06/25.
//

import FacebookCore

final class FacebookEvents {
    class func logEvent(event: AppConstants.analyticsEvent) {
        let parameters: [AppEvents.ParameterName: Any] = [
            AppEvents.ParameterName("device_id"): Device.id
        ]
        
        AppEvents.shared.logEvent(AppEvents.Name(event.rawValue), parameters: parameters)
    }
}
