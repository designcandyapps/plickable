//
//  HeaderView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 05/03/25.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    var iButtonAction: (() -> Void)?
    var eulaButtonAction: (() -> Void)?
    var privacyButtonAction: (() -> Void)?

    var body: some View {
        VStack (alignment: .leading) {
            Image(.logoTextWhite)
                .resizable()
                .scaledToFit()
                .frame(width: Screen.width * 0.3, height: Screen.height * 0.075)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .topTrailing) {
                    HStack(spacing: 4) {
                        if eulaButtonAction != nil {
                            eulaButton
                        }
                        
                        if privacyButtonAction != nil {
                            privacyButton
                        }
                        
                        if iButtonAction != nil {
                            iButton
                        }
                    }
                    .padding(.trailing, 16)
                }
            
            Text(title)
                .font(.gothamBold(.title1))
            
            Text(subtitle)
                .font(.gothamLight(.title3))
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(Color.white)
        .padding()
        .frame(maxWidth: Screen.width, alignment: .leading)
        .padding(.leading)
    }
    
    private var eulaButton: some View {
        Button {
            guard let eulaButtonAction else { return }
            eulaButtonAction()
        } label: {
            Text("EULA")
                .font(.gothamMedium(.caption2))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay {
                    Capsule()
                        .strokeBorder(lineWidth: 1.5)
                }
        }
    }
    
    private var iButton: some View {
        Button {
            guard let iButtonAction else { return }
            iButtonAction()
        } label: {
            Image(systemName: "info.circle")
                .font(.title3)
                .padding()
        }
    }
    
    private var privacyButton: some View {
        Button {
            guard let privacyButtonAction else { return }
            privacyButtonAction()
        } label: {
            Text("PRIVACY")
                .font(.gothamMedium(.caption2))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay {
                    Capsule()
                        .strokeBorder(lineWidth: 1.5)
                }
        }
    }
}

var disclaimerAlert: Alert {
    Alert(title: Text("Disclaimer"),
          message: Text("The information provided by the Kwell app is for informational purposes only. It is not a substitute for professional medical advice, diagnosis or treatment. You should always seek advice from a doctor or other qualified healthcare provider regarding any health concerns or before making any decisions about your health based on information you've read or heard, as the information provided is not a substitute for professional medical advice."),
          dismissButton: .default(Text("I Understand")))
}

#Preview {
    HeaderView(title: "Morning motivation.", subtitle: "Assess your speech", iButtonAction: { })
}
