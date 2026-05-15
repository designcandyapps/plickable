//
//  BinauralView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 28/10/24.
//

import SwiftUI
import AVFoundation

struct BinauralBeatsView: View {
    @StateObject var vm = BinauralBeatsVM()
    
    @Binding var showBinauralView: Bool
    let detectedResult: DetectResponse?
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .center) {
            // Background Color
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack(alignment: .center) {
                header()
                
                Spacer()
                
                details()
                
                Spacer()
                
                stopButton()
            }
            .padding()
        }
        .task {
            vm.startPlaying(beatFrequencyValue: detectedResult?.result.maxEmotion.beatFrequency ?? 0)
        }
        .onAppear {
//            FIRAnalytics.logEvent(event: .playBeats)
        }
    }
    
    // MARK: - Header
    private func header() -> some View {
        Text("Playing Binaural Beats")
            .foregroundStyle(Color.white)
            .font(.custom("Gotham-Bold", size: 30))
            .multilineTextAlignment(.center)
            .padding(.vertical)
    }
    
    // MARK: - Details
    private func details() -> some View {
        VStack (spacing: 10) {
            detailRow("Detected Emotion", detectedResult?.result.maxEmotion.rawValue.capitalized ?? "")
            detailRow("Base Frequency", vm.baseFrequencyValue.formatted(.number))
            detailRow("Beat Frequency", detectedResult?.result.maxEmotion.beatFrequency.formatted(.number) ?? "0")
        }
        .foregroundStyle(Color.white)
        .padding()
    }
    
    private func detailRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.custom("Gotham-Medium", size: 20))
            Spacer()
            Text(value)
                .font(.custom("Gotham-Book", size: 20))
        }
    }
    
    // MARK: - Stop Button
    private func stopButton() -> some View {
        Button {
//            FIRAnalytics.logEvent(event: .stopBeats)
            
            Task {
                await vm.stopPlaying(id: detectedResult?.id ?? 0)
            }
            showBinauralView.toggle()
            action()
        } label: {
            Text("Stop Binaural Beats")
                .foregroundStyle(Color.backgroundPrimary)
                .font(.custom("Gotham-Book", size: 20))
                .frame(width: Screen.width * 0.7)
                .padding(20)
                .background {
                    Capsule()
                        .foregroundStyle(Color.white)
                }
                .padding(.bottom)
        }
    }
}

#Preview {
    BinauralBeatsView(showBinauralView: .constant(true),
                      detectedResult: DetectResponse(result: Result(text: "Optimism",
                                                                    maxEmotion: .optimism,
                                                                    score: 0),
                                                     id: 0),
                      action: {}
    )
}
