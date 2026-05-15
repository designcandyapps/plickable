//
//  RootView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 11/11/24.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .dashboard
    @State var showSplashScreen: Bool = true
    
    @EnvironmentObject var subscriptionsManager: SubscriptionsManager
    @EnvironmentObject var configManager: ConfigManager
    
    // MARK: View Models
    @StateObject var dashboardVM = DashboardVM()
    @StateObject var analyticsVM = AnalyticsVM()
    @StateObject var profileVM = ProfileVM()
    
    private var showSubscriptions: Binding<Bool> {
        Binding(
            get: { !subscriptionsManager.hasPro },
            set: { subscriptionsManager.hasPro = !$0 }
        )
    }
    
    private var hasNotchOrDynamicIsland: Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                let safeAreaInsets = keyWindow.safeAreaInsets
                
                // Check if the top safe area inset is greater than a typical value (indicates notch/Dynamic Island)
                return safeAreaInsets.top > 20 ? true : false
            }
        }
        return false
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            // MARK: - Tab's View
            VStack {
                Group {
                    switch selectedTab {
                    case .dashboard:
                        DashboardView(vm: dashboardVM)
                    case .profile:
                        ProfileView(vm: profileVM) {
                            selectedTab = .dashboard
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                dashboardVM.startRecording()
                            }
                        }
                    case .analytics:
                        AnalyticsView(vm: analyticsVM)
                    }
                }
                .padding(.top, hasNotchOrDynamicIsland ? Screen.height * 0.05 : 0)
                .padding(.bottom, hasNotchOrDynamicIsland ? nil : 0)
                .frame(height: Screen.height * 0.825)
                
                // MARK: - Tab Bar
                VStack {
                    Spacer()
                    CustomTabBarView(selectedTab: $selectedTab)
                }
                .ignoresSafeArea()
            }
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
            .onReceive(NotificationCenter.default.publisher(for: .receivedDetectedEmotion))
            { _ in
                Task {
                    await analyticsVM.fetchAnalytics()
                    await profileVM.loadData()
                }
            }
        }
        .background(Color.backgroundPrimary)
        .restrictUsage(condition: $configManager.isOutdated)
        .task {
            await configManager.fetchData()
            await subscriptionsManager.loadProducts(productIDs: configManager.availableProducts)
            await analyticsVM.fetchAnalytics()
            await profileVM.loadData()
        }
        .fullScreenCover(isPresented: showSubscriptions) {
            SubscriptionsView()
                .restrictUsage(condition: $configManager.isOutdated)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SubscriptionsManager())
}
