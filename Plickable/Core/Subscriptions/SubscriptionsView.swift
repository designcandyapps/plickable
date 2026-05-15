//
//  SubscriptionsView.swift
//  Kwell
//
//  Created by Hitesh Rupani on 22/08/25.
//

import SwiftUI
import StoreKit

struct SubscriptionsView: View {
    
    @EnvironmentObject var subscriptionsManager: SubscriptionsManager
    @State private var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            background
            
            VStack {
                textContent
                subscriptionBottomSheet
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: subscriptionsManager.products) { products in
            if selectedProduct == nil && !products.isEmpty {
                selectedProduct = products.first
            }
        }
    }
    
    private var background: some View {
        LinearGradient(
            gradient: .init(
                stops: [
                    .init(color: .backgroundPrimary, location: 0.25),
                    .init(color: .backgroundSecondary, location: 0.75),
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your emotions are talking. Are you listening?")
                .font(.gothamBold(size: 32))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            
            // MARK: - Bullet Points
            VStack (alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Track your emotional patterns over time.")
                }
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Receive tailored insights to improve sleep, focus and calm.")
                }
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Get personalized binaural audio based on your voice.")
                }
            }
            .font(.gothamMedium(size: 16))
            .foregroundStyle(.white)
            
            VStack (spacing: 2) {
                Text("Kwell transforms your voice into wellness guidance.")
                Text("Start your journey today.")
            }
            .font(.gotham(size: 12))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .frame(height: Screen.height * 0.6)
    }
    
    private var subscriptionBottomSheet: some View {
        VStack (spacing: 16) {
            subscriptionOptions
            
            purchaseButton
            
            restorePurchasesButton
            
            VStack(spacing: 4) {
                Text("Cancel anytime - no charge during trial")
                Text("No ads. No data selling. Just insight.")
            }
            .font(.gotham(size: 12))
            .foregroundStyle(.black)
            
            Spacer()
        }
        .padding(16)
        .frame(width: Screen.width * 0.85,
               height: Screen.height * 0.45)
        .background {
            Color.white
                .clipShape(
                    .rect(
                        cornerRadii: .init(
                            topLeading: 24,
                            bottomLeading: 0,
                            bottomTrailing: 0,
                            topTrailing: 24
                        )
                    )
                )
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            Text("Free for 3 days")
                .textCase(.uppercase)
                .font(.gothamMedium(size: 14))
                .foregroundStyle(Color.white)
                .frame(width: Screen.width * 0.55, height: 32)
                .background {
                    Color.backgroundPrimary
                        .clipShape(.capsule)
                }
                .offset(y: -16)
        }
        .shadow(radius: 10)
    }
    
    private var subscriptionOptions: some View {
        VStack(spacing: 8){
            if subscriptionsManager.products.isEmpty {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .tint(Color.backgroundPrimary)
                    .padding()
                    .frame(height: Screen.height * 0.132)
                
            } else {
                ForEach(subscriptionsManager.products) { product in
                    HStack (spacing: 16) {
                        Circle()
                            .stroke(Color.backgroundPrimary)
                            .frame(width: 24)
                            .overlay {
                                if selectedProduct == product {
                                    Circle()
                                        .fill(.backgroundPrimary)
                                        .frame(width: 16)
                                }
                            }
                        
                        Text(product.displayPrice + " - " + product.displayName)
                            .font(.gotham(size: 14))
                            .foregroundStyle(selectedProduct == product ? .backgroundPrimary : .black)
                        
                    }
                    .padding(.horizontal, 16)
                    .frame(width: Screen.width * 0.7,
                           height: Screen.height * 0.066,
                           alignment: .leading)
                    .overlay {
                        if selectedProduct == product {
                            Capsule()
                                .strokeBorder(Color.backgroundPrimary)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedProduct = product
                    }
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var purchaseButton: some View {
        Button {
            guard let selectedProduct else { return }
            
            Task {
                await subscriptionsManager.buyProduct(selectedProduct)
            }
        } label: {
            Text("Start Free Trial")
                .font(.gothamMedium(size: 18))
                .foregroundStyle(.white)
                .frame(width: Screen.width * 0.7,
                       height: Screen.height * 0.066)
                .background {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.backgroundPrimary,
                                         .backgroundSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
        }
    }
    
    private var restorePurchasesButton: some View {
        Button {
            Task {
                await subscriptionsManager.restorePurchases()
            }
        } label: {
            Text("Restore Purchases")
                .font(.gothamMedium(size: 16))
                .foregroundStyle(.backgroundPrimary)
        }
    }
}

#Preview {
    SubscriptionsView()
        .environmentObject(SubscriptionsManager())
}
