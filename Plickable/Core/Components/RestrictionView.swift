//
//  RestrictionView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 07/09/25.
//

import SwiftUI

struct RestrictionView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                VStack (spacing: 16){
                    VStack(spacing: 8) {
                        Text("Version Outdated!")
                            .font(.gothamMedium(.headline))
                        Text("Please update the app to continue using Kwell.")
                            .font(.gotham(.subheadline))
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6547859478"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    } label: {
                        Text("Update Now")
                            .font(.gothamBold(.headline))
                            .foregroundStyle(.backgroundPrimary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .foregroundStyle(.white)
                .frame(width: Screen.width * 0.6)
                .padding(16)
                .background(.backgroundPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 10)
            }
    }
}

extension View {
    func restrictUsage(condition: Binding<Bool>) -> some View {
        Group {
            if condition.wrappedValue {
                self.modifier(RestrictionView())
            } else {
                self
            }
        }
    }
}
