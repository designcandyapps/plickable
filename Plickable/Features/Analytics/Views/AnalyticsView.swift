//
//  AnalyticsView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 14/10/24.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var vm: AnalyticsVM
    
    @State private var selectedData: AnalyticsData? = nil
    @State private var popupPosition: CGPoint = .zero
//    @State private var hidePopupWorkItem: DispatchWorkItem?
    
//    enum AlertFor {
//        case header
//        case legends
//    }
//    @State var alertFor: AlertFor = .header
//    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundPrimary.ignoresSafeArea()
            
            // MARK: - Placeholder
            if vm.analytics.isEmpty {
                placeholder
            }
            
            VStack (alignment: .center, spacing: 0) {
                header
                
                Spacer()
                
                if !vm.analytics.isEmpty {
                    ZStack {
                        yAxisBackground
                        
                        HStack (alignment: .bottom, spacing: 5) {
                            monthLabel(Color.white)
                            
                            ZStack (alignment: .center) {
                                chart()
                                
                                if let selectedData, let emotion = selectedData.emotion?.rawValue {
                                    popup(text: "\(emotion)"/*\n\(data.binauralDuration ?? 0) secs*/)
                                }
                            }
                            .padding(.bottom)
                            .frame(height: Screen.height * 0.5, alignment: .bottom)
                            
                            monthLabel(.clear)
                        }
                        .padding(.horizontal)
                    }
                    footer
                }
                Spacer()
            }
        }
        .padding(.vertical)
        .frame(height: Screen.height * 0.825)
        .onAppear {
            FIRAnalytics.logEvent(event: .openStats)
            FacebookEvents.logEvent(event: .openStats)
        }
        .onDisappear {
            // cancelling pending operations
//            hidePopupWorkItem?.cancel()
            
            selectedData = nil
        }
//        .alert(isPresented: $showAlert) {
//            switch alertFor {
//            case .header:
//                headerAlert
//            case .legends:
//                legendsAlert
//            }
//        }
    }
}

#Preview {
    AnalyticsView(vm: AnalyticsVM())
}

// MARK: - SubView Functions
extension AnalyticsView {
    private var header: some View {
        VStack {
            Text("Analyze emotion")
                .font(.custom("Gotham-Bold", size: 30))
            
            Text("in your voice")
                .font(.custom("Gotham-Light", size: 25))
                .opacity(0.8)
        }
        .foregroundStyle(Color.white)
        .padding()
        .frame(height: Screen.height * 0.2)
        .frame(maxWidth: .infinity)
//        .overlay(alignment: .trailing) {
//            Button {
//                alertFor = .header
//                showAlert = true
//            } label: {
//                Image(systemName: "info.circle")
//                    .font(.title3)
//                    .padding()
//            }
//            .padding(.top)
//        }
    }
    
//    private var headerAlert: Alert {
//        Alert(
//            title: Text("Binaural Beats"),
//            message: Text("Binaural beats are a perceived sound created when two different tones are played, and the brain interprets them as a third tone called a binaural beat. They can help reduce stress, improve sleep, and boost creativity. Used in conjunction with our voice analyzer, you can monitor your overall health using the \"biofeedback score\", a personalized metric that combines heart rate, sleep quality, activity levels, and stress."),
//            dismissButton: .default(Text("OK"))
//        )
//    }
    
    private func chart() -> some View {
        Chart {
            ForEach (vm.analytics, id: \.self) { data in
//                BarMark (
//                    x: .value("Time", data.timestamp),
//                    y: .value("Duration", Double(data.binauralDuration ?? 0)),
//                    width: vm.analytics.count <= 2 ? 35 : 25
//                )
//                .foregroundStyle(Color.duration)
//                .cornerRadius(0)
                
                BarMark (
                    x: .value("Time", data.timestamp),
                    y: .value("Emotional Affect", data.emotion?.height ?? 0 /** 5*/),
                    width: vm.analytics.count <= 2 ? 35 : 25
                )
                .foregroundStyle(Color.effect)
                .cornerRadius(0)
            }
        }
        .chartYAxis(.hidden)
        .chartYScale(domain: 0...34)
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let timestamp = value.as(String.self) {
                        let day = DateMethods.convertToLocalTimeZone(from: timestamp, type: .dd)
                        Text(day ?? "")
                            .font(.custom("Gotham-Book", size: 11.5))
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .frame(
            maxWidth: max((Double(vm.analytics.count) * (Screen.width/13)), 90),
            maxHeight: Screen.height * 0.5
        )
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // cancelling pending operations
//                                hidePopupWorkItem?.cancel()
                                
                                let currentX = value.location.x
                                
                                // calculating selected data
                                let barWidth = geometry.size.width / CGFloat(vm.analytics.count)
                                let index = Int(currentX / barWidth)
                                
                                guard index >= 0 && index < vm.analytics.count else { return }
                                
                                let data = vm.analytics[index]
                                selectedData = data
                                
                                // Calculate the max Y value from duration and emotion
                                //                                                    let durationY = Double(data.binauralDuration ?? 0)
                                let emotionY = data.emotion?.height ?? 0 /** 5*/
                                let maxY = emotionY /*max(durationY, durationY + emotionY)*/
                                
                                // Use proxy to get positions
                                if let xPos = proxy.position(forX: data.timestamp),
                                   let yPos = proxy.position(forY: maxY) {
                                    popupPosition = CGPoint(x: xPos, y: yPos)
                                }
                            }
//                            .onEnded { _ in
//                                // creating new work item for hiding popup
//                                let workItem = DispatchWorkItem {
//                                    selectedData = nil
//                                }
//                                hidePopupWorkItem = workItem
//                                
//                                //scheduling hide operation
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
//                            }
                    )
            }
        }
    }
    
    private var yAxisBackground: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            
            VStack (alignment: .leading, spacing: 0) {
                yAxisLabel(title: "Joy", heightSize: height * (3 / 34))
                yAxisLabel(title: "Optimism", heightSize: height * (8 / 34))
                yAxisLabel(title: "Neutral", heightSize: height * (7 / 34))
                yAxisLabel(title: "Approval", heightSize: height * (8 / 34))
                yAxisLabel(title: "Anger", heightSize: height * (5 / 34))
                yAxisLabel(title: "Sad", heightSize: height * (3 / 34), lineHidden: true)
            }
        }
        .padding([.bottom, .horizontal])
        .padding(.bottom, 17.5)
        .frame(height: Screen.height * 0.5)
    }
    
    private func yAxisLabel(title: String, heightSize: CGFloat, lineHidden: Bool = false) -> some View {
        VStack (alignment: .leading) {
            Spacer()
            
            Text(title.uppercased())
                .font(.custom("Gotham-Medium", size: 8.75))
                .foregroundStyle(Color.white)
                .frame(minWidth: 60)
                .rotationEffect(.init(degrees: -90))
                .offset(x: -22, y: 0)

            Spacer()
            
            if !lineHidden {
                HStack {
                    Rectangle()
                        .frame(width: 16, height: 1)
                    
                    Rectangle()
                        .frame(height: 1)
                }
                .foregroundStyle(Color.white)
            }
        }
        .frame(height: heightSize)
    }
    
    private func popup(text: String) -> some View {
        PopupView(text: text)
            .position(x: popupPosition.x, y: popupPosition.y)
            .frame(
                maxWidth: max((Double(vm.analytics.count) * (Screen.width/13)), 90),
                maxHeight: Screen.height * 0.5
            )
    }
    
    private func monthLabel(_ color: Color) -> some View {
        Text(vm.analytics.first?.month ?? "")
            .textCase(.uppercase)
            .font(.custom("Gotham-Book", size: 11.5))
            .foregroundStyle(color)
            .padding(.bottom)
    }
    
    private var footer: some View {
//        ZStack {
            legends
                .padding()
            
//            infoButton
//        }
    }
    
    private var legends: some View {
        HStack (alignment: .top, spacing: 20) {
            // Emotional Affect
            HStack (alignment: .top) {
                Circle()
                    .fill(Color.effect)
                    .frame(width: 15)
                
                Text("Emotional Affect")
                    .textCase(.uppercase)
                    .foregroundStyle(Color.white)
            }
            
            // Duration
//            HStack(alignment: .top) {
//                Circle()
//                    .fill(Color.duration)
//                    .frame(width: 15)
//
//                Text("Duration of\nBinaural Beats\nListening")
//                    .textCase(.uppercase)
//                    .foregroundStyle(Color.white)
//                    .multilineTextAlignment(.leading)
//            }
        }
        .font(.custom("Gotham-Book", size: 12))
        .frame(width: Screen.width * 0.8)
    }
    
//    private var infoButton: some View {
//        HStack {
//            Spacer()
//            
//            Button {
//                alertFor = .legends
//                showAlert = true
//            } label : {
//                Image(systemName: "info.circle")
//                    .padding()
//                    .offset(y: -11)
//            }
//        }
//        .padding(.bottom)
//    }
    
//    private var legendsAlert: Alert {
//        Alert(
//            title: Text("Legends"),
//            message: Text("Emotional Affect refers to the magnitude assigned to each emotion. The higher the number, the better the emotion. These are the possible emotions in descending order:\n1. Joy\n2. Optimism\n3. Neutral\n4. Approval\n5. Anger\n6. Sadness\n" + "Duration of Binaural Beats Listening refers to the time spent listening to binaural beats in seconds."),
//            dismissButton: .default(Text("Got it!"))
//        )
//    }
    
    private var placeholder: some View {
        VStack (alignment: .center) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.width * 0.3)
                .padding(.bottom, 5)
            Text("Oops! No data available!")
                .font(.gotham(.title3))
                .fontWeight(.medium)
            Text("Start recording to see analytics...")
                .font(.gotham(.headline))
                .fontWeight(.light)
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal)
    }
}
