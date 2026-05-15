//
//  ProfileView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 14/10/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileVM
    @State var switchToDashboard: (() -> Void)

    // MARK: - Alert Variables
    enum AlertFor {
        case healthKitAuth
        case bioFeedbackInfo
    }
    @State private var showAlert: Bool = false
    @State private var alertFor: AlertFor = .bioFeedbackInfo
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // background
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 0){
                VStack (spacing: 0) {
                    HeaderView(
                        title: "Your emotions",
                        subtitle: "at a glance",
                        eulaButtonAction: {
                            if let url = URL(string: "https://kwell.app/dev/eula.php") {
                                UIApplication.shared.open(url)
                            }
                        }, privacyButtonAction: {
                            if let url = URL(string: "https://kwell.app/dev/privacy-policy.php") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                    biofeedbackScore(
                        biofeedbackScore: vm.bioFeedbackScore,
                        improvementPercentage: vm.improvementPercentage,
                        height: Screen.height * 0.115
                    )
                    
                    description
                }
                
                Spacer()
                
                RecordAgainButton {
                    switchToDashboard()
                }
            }
        }
        .padding(.vertical)
        .frame(height: Screen.height * 0.825)
        .onAppear {
            FIRAnalytics.logEvent(event: .openProfile)
            FacebookEvents.logEvent(event: .openProfile)
            
//            if vm.showHealthKitAuthAlert {
//                alertFor = .healthKitAuth
//                showAlert = vm.showHealthKitAuthAlert
//            }
        }
        .task {
            await vm.loadData()
        }
//        .alert(isPresented: $showAlert) {
//            displayAlert
//        }
    }
    
    // MARK: - SubViews
    
    private func biofeedbackScore(
        biofeedbackScore: Double,
        improvementPercentage: Double,
        height: CGFloat
    ) -> some View {
        var improvementPercentageToDisplay: String {
            improvementPercentage
                .magnitude
                .formatted(.percent.precision(.fractionLength(0)))
        }
        
        return HStack {
            VStack (alignment: .leading) {
                Text("Biofeedback Score:")
                    .font(.gothamMedium(.subheadline))
                
//                HStack {
                    Text(String(format: "%.2f", biofeedbackScore))
                        .font(.gothamBold(.title1))
                    
//                    Button {
//                        alertFor = .bioFeedbackInfo
//                        showAlert = true
//                    } label: {
//                        Image(systemName: "info.circle")
//                            .font(.subheadline)
//                            .frame(alignment: .top)
//                    }
//                }
            }
            
            Spacer(minLength: 0)
            
            Divider()
                .frame(width: 1)
                .background(Color.white)
            
            Spacer(minLength: 0)
            
            HStack {
                if improvementPercentage != 0 {
                    Image(systemName: "\(improvementPercentage < 0 ? "arrow.down" : "arrow.up")")
                        .fontWeight(.black)
                        .font(.title3)
                }
                
                Text(improvementPercentageToDisplay)
                    .font(.gothamBold(.title1))
            }
            
            Spacer(minLength: 0)
        }
        .foregroundStyle(Color.white)
        .padding()
        .frame(maxWidth: Screen.width * 0.8, maxHeight: height, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white, lineWidth: 1)
        }
    }
    
    private var description: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text("Your biofeedback score is an average of four main health components under Apple HealthKit that include your emotional affect. You can monitor changes in your affect, and how it effects your score to obtain a heightened awareness of your overall health via changes in emotional affect.")
                .multilineTextAlignment(.leading)
                .font(.gotham(.subheadline))
                .frame(width: Screen.width * 0.8, alignment: .leading)
        }
        .padding()
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
    
//    private var displayAlert: Alert {
//        switch alertFor {
//        case .healthKitAuth:
//            return Alert(
//                title: Text("HealthKit Access Required"),
//                message: Text("To provide you with a personalized biofeedback score, we require access to your HealthKit data. This score helps you understand your overall health by using the data already on your device. Rest assured, your privacy is our top priority and the information is used only to generate your biofeedback score."),
//                dismissButton: .default(Text("Continue")) {
//                    FIRAnalytics.logEvent(event: .openHealthKit)
//                    
//                    vm.showHealthKitAuthAlert = false
//                }
//            )
//            
//        case .bioFeedbackInfo:
//            return Alert(
//                title: Text("Biofeedback Score"),
//                message: Text("The Kwell app displays a general health status score called a \"biofeedback score.\"\nThis calculation provides greater awareness of many physiological functions of one's own body by using electronic or other instruments, and with a goal of being able to manipulate the body's systems at will. It is calculated via user-provided input from the Apple Health app."),
//                primaryButton: .default(Text("OK")),
//                secondaryButton: .default(Text("Learn more"), action: {
//                    if let url = URL(string: "https://kwell.app/dev/biofeedback-score.php") {
//                        UIApplication.shared.open(url)
//                    }
//                })
//            )
//        }
//    }
}

#Preview {
    ProfileView(vm: ProfileVM(), switchToDashboard: {
        print("Switching to Dashboard")
    })
}
