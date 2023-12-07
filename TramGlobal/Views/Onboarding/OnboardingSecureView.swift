//
//  OnboardingSecureView.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI

struct OnboardingSecureView: View {
    @State private var isAnimating: Bool = false
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        
        ZStack {
            linear_background_color1()
            
            VStack {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .padding(.top, 10)
                
                Text("TramGlobal UMS")
                    .font(.system(size: 25, weight: .regular))
                    .offset(y: -5)
                    .padding(.bottom, 20)
                
                Image("OnboardingSecure")
                    .scaleEffect(isAnimating ? 1 : 0.9)
                    .padding(.bottom, 10)
                
                Text("Secure and Responsive")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)
                
                Text("Experience the peace of mind with TramGlobal's secure user management system, offering robust data security and a responsive, user-friendly interface for seamless administration.")
                    .font(.footnote)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.leading, 35)
                    .padding(.trailing, 35)
                
                Spacer()
                
                Button(action: {
                    isOnboarding = false
                }, label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(
                                    k_app_theme_color
                                )
                        )
                })
                .shadow(radius: 10)
                
                Spacer()
            }
        }
        .onAppear(perform: {
            isAnimating = false
            withAnimation(.easeOut(duration: 0.5)) {
                self.isAnimating = true
            }
        })
    }
}

struct OnboardingSecureView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSecureView()
    }
}
