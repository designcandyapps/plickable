//
//  RecordAgainButton.swift
//  Kwell
//
//  Created by Hitesh Rupani on 28/05/25.
//

import SwiftUI

struct RecordAgainButton: View {
    var disabled: Bool = false
    var tapAction: () -> Void
    
    var body: some View {
        Button {
            FIRAnalytics.logEvent(event: .recordAgain)
            FacebookEvents.logEvent(event: .recordAgain)
            
            tapAction()
        } label: {
            Text("Record again")
                .font(.custom("Gotham-Medium", size: 20))
                .foregroundStyle(Color.white)
                .frame(width: Screen.width * 0.7)
                .padding(20)
                .overlay {
                    Capsule()
                        .strokeBorder(Color.white, lineWidth: 2) // Stroke inside the bounds
                }
                .frame(maxWidth: .infinity)
                .frame(height: Screen.height * 0.1)
        }
        .opacity(disabled ? 0.5 : 1)
        .disabled(disabled)
    }
}
