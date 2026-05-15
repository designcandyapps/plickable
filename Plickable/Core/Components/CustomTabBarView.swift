//
//  CustomTabBarView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 11/11/24.
//

import SwiftUI

enum Tabs: Int {
    case dashboard = 0
    case analytics = 1
    case profile = 2
}

struct CustomTabBarView: View {
    @Binding var selectedTab: Tabs
    
    private let iconSize: CGFloat = 36
    
    private let tabBarWidth: CGFloat = Screen.width
    private let tabBarHeight: CGFloat = Screen.height * 0.125
    private let tabBarIconWidth: CGFloat = Screen.width / 3
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                // MARK: - Home Tab
                TabIconView(
                    iconName: "icon1",
                    iconWidth: iconSize,
                    iconHeight: iconSize
                )
                .frame(width: tabBarIconWidth, height: tabBarHeight)
                .background{
                    if !(selectedTab == .dashboard) {
                        Color.backgroundSecondary
                    }
                }
                .onTapGesture {
                    selectedTab = .dashboard
                }
                
                // MARK: - Analytics Tab
                TabIconView(
                    iconName: "icon2",
                    iconWidth: iconSize,
                    iconHeight: iconSize
                )
                .frame(width: tabBarIconWidth, height: tabBarHeight)
                .background{
                    if !(selectedTab == .analytics) {
                        Color.backgroundSecondary
                    }
                }
                .onTapGesture {
                    selectedTab = .analytics
                }
                
                // MARK: - Profile Tab
                TabIconView(
                    iconName: "icon3",
                    iconWidth: iconSize,
                    iconHeight: iconSize
                )
                .frame(width: tabBarIconWidth, height: tabBarHeight)
                .background{
                    if !(selectedTab == .profile) {
                        Color.backgroundSecondary
                    }
                }
                .onTapGesture {
                    selectedTab = .profile
                }
            }
        }
        .frame(width: tabBarWidth, height: tabBarHeight)
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView(selectedTab: .constant(.dashboard))
            .previewLayout(.sizeThatFits)
    }
}

struct TabIconView: View {
    var iconName: String
    var iconWidth: CGFloat
    var iconHeight: CGFloat
    
    var body: some View {
        Image(iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconWidth, height: iconHeight)
            .offset(y: -5)
            
    }
}
