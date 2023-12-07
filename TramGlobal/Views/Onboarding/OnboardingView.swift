//
//  OnboardingView.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentTab = 0
    
    var body: some View {
        TabView(selection: $currentTab,
                content:  {
            OnboardingWelcomeView()
                .tag(0)
            OnboardingProfileView()
                .tag(1)
            OnboardingSecureView()
                .tag(3)
        })
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//        .preferredColorScheme(.dark))
        
        .onAppear() {
            setupAppearance()
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .blue
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.blue.withAlphaComponent(0.2)
    }
}

#Preview {
    OnboardingView()
}
