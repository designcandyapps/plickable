//
//  PlickableApp.swift
//  Plickable
//
//  Created by Hitesh Rupani on 08/10/24.
//

import SwiftUI

@main
struct PlickableApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var subscriptionsManager: SubscriptionsManager = .init()
    @StateObject private var configManager = ConfigManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(subscriptionsManager)
                .environmentObject(configManager)
                .task {
                    await subscriptionsManager.updatePurchasedProducts()
                }
        }
    }
}
