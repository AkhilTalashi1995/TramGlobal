//
//  OnboardingProfileView.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI

struct OnboardingProfileView: View {
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
                
                Image("OnboardingProfile")
                    .scaleEffect(isAnimating ? 1 : 0.9)
                    .padding(.bottom, 10)
                
                
                Text("Create and Edit Profiles")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)
                
                Text("Effortlessly add and update user profiles with our intuitive system, giving you complete control over user information and ensuring accurate records.")
                    .font(.footnote)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                
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

struct OnboardingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingProfileView()
    }
}
