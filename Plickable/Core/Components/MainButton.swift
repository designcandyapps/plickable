//
//  MainButton.swift
//  Kwell
//
//  Created by Hitesh Rupani on 28/05/25.
//

import SwiftUI

struct MainButton: View {
    var title: String
    var disabled: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text (title)
                .foregroundStyle(Color.backgroundPrimary)
                .font(.custom("Gotham-Book", size: 20))
                .frame(width: Screen.width * 0.7)
                .padding(20)
                .background {
                    Capsule()
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: Screen.height * 0.1)
        }
        .opacity(disabled ? 0.5 : 1)
        .disabled(disabled)
    }
}
