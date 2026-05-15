//
//  DashboardView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 08/10/24.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var vm: DashboardVM
    
    @State private var showDisclaimer: Bool = false
    @State private var showBinauralView: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // backgroundPrimary Color
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 0) {
                // MARK: - Header
                HeaderView(
                    title: "Check your emotion.",
                    subtitle: "Record your voice to detect your mood",
                    iButtonAction: {
                        showDisclaimer = true
                    }
                )
                .alert(isPresented: $showDisclaimer) {
                    disclaimerAlert
                }
                
                Spacer()
                
                // MARK: - Center View
                switch vm.state {
                case .idle, .recording:
                    counter()
                case .processing:
                    processing()
                case .completed, .binauralBeats:
                    result()
                }
                
                Spacer()
                
                // MARK: - Button
                
                switch vm.state {
                case .idle, .binauralBeats:
                    MainButton(
                        title: vm.state.buttonTitle.capitalized,
                        disabled: vm.state == .recording && !vm.canStopRecording || vm.state == .processing
                    ) {
                        vm.startRecording()
                    }
                case .recording:
                    MainButton(
                        title: vm.state.buttonTitle.capitalized,
                        disabled: vm.state == .recording && !vm.canStopRecording || vm.state == .processing
                    ) {
                        Task {
                            await vm.stopRecording()
                        }
                    }
                case .completed, .processing:
                    RecordAgainButton(
                        disabled: vm.state == .recording && !vm.canStopRecording || vm.state == .processing
                    ) {
                        vm.startRecording()
                    }
                }
                
            }
        }
        .padding(.vertical)
        .frame(height: Screen.height * 0.825)
        .fullScreenCover(isPresented: $showBinauralView) {
            BinauralBeatsView(
                showBinauralView: $showBinauralView,
                detectedResult: vm.detectedResult,
                action: {
                    vm.state = .binauralBeats
                }
            )
        }
    }
    
    // MARK: - SubView Functions
    
    // MARK: - Counter
    private func counter() -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.25)
            
            Circle()
                .trim(from: 0, to: CGFloat(vm.timeRemaining)/5)
                .stroke(lineWidth: 5)
                .rotationEffect(.degrees(-90))
            
            Text("0\(Int(vm.timeRemaining))")
                .font(.custom("Gotham-Medium", size: 50))
        }
        .foregroundStyle(Color.white)
        .frame(width: Screen.width * 0.45,
               height: Screen.height * 0.4)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Processing
    private func processing() -> some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5, anchor: .center)
                .tint(Color.white)
                .padding()
            Text("Processing...")
                .foregroundStyle(Color.white)
                .font(.custom("Gotham-Light", size: 17))
        }
        .frame(height: Screen.height * 0.4)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Result
    private func result() -> some View {
        VStack {
            Text("Detected Emotion:")
                .font(.custom("Gotham-Light", size: 20))
                .opacity(0.8)
            
            Text(vm.detectedResult?.result.maxEmotion.rawValue.capitalized ?? "")
                .font(.custom("GothamNarrow-BoldItalic", size: 30))
        }
        .foregroundStyle(Color.white)
        .frame(height: Screen.height * 0.4)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashboardView(vm: DashboardVM())
}
