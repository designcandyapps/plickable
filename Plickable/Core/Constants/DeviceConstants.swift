//
//  Constants.swift
//  Kwell
//
//  Created by Hitesh Rupani on 15/01/25.
//

import UIKit

struct Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

struct Device {
    static let id = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
}
