//
//  Methods.swift
//  Kwell
//
//  Created by Hitesh Rupani on 16/01/25.
//

import Foundation

enum DateType {
    case dd
    case MMM
    case ddMMyyyy
    case all
}

struct DateMethods {
    // date in ISO Format
    static func dateInISOFormat(_ date: Date = Date()) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoDateFormatter.timeZone = .gmt
        return isoDateFormatter.string(from: date)
    }
    
    // to convert UTC date to local time zone
    static func convertToLocalTimeZone(from timestamp: String, type: DateType = .all) -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoDateFormatter.date(from: timestamp) else {
            return nil
        }
        
        let localFormatter = DateFormatter()
        localFormatter.timeZone = TimeZone.current
        
        switch type {
        case .all:
            localFormatter.dateStyle = .medium
            localFormatter.timeStyle = .medium
        case .dd:
            localFormatter.dateFormat = "dd"
        case .MMM:
            localFormatter.dateFormat = "MMM"
        case .ddMMyyyy:
            localFormatter.dateFormat = "dd MM yyyy"
        }
        
        return localFormatter.string(from: date)
    }
}
