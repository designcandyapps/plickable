//
//  PopupView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 30/12/24.
//

import SwiftUI

struct PopupView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Gotham-Book", size: 12))
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.white)
            .padding(10)
            .background{
                ZStack {
                    ZStack {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(height: 40)
                            .frame(maxWidth: 90)
                        
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .rotationEffect(.degrees(45))
                            .frame(width: 30, height: 30)
                            .offset(y: 5 )
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 40)
                            .frame(maxWidth: 90)
                        
                        Rectangle()
                            .fill(Color.black)
                            .rotationEffect(.degrees(45))
                            .frame(width: 30, height: 30)
                            .offset(y: 5 )
                    }
                }
            }
        
        
    }
}

struct Preview_PopupView: PreviewProvider {
    static var previews: some View {
        PopupView(text: "Optimism\n0 secs")
            .previewLayout(.sizeThatFits)
    }
}
