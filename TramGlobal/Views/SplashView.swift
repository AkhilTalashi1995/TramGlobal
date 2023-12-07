//
//  SplashView.swift
//  TramGlobal
//
//  Created by Akhil on 02/12/23.
//

import Foundation
import SwiftUI

struct SplashView: View {
    
    @State var isHomeViewActive: Bool = false
    @State var isAnimateText = false
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @AppStorage("isUserLogin") var isUserLogin: Bool = false
    
    var body: some View {
        ZStack {
            if self.isHomeViewActive {
                if isOnboarding {
                    OnboardingView()
                } else {
                    if isUserLogin {
                        TabsView()
                    } else {
                        NavigationStack {
                            SignInView()
                        }
                    }
                }
            } else {
                linear_background_color()
                
                HStack {
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                    
                    Text("TramGlobal UMS")
                        .font(.system(size: 30, weight: .medium))
                        .animation(.easeIn(duration: 5.0), value: isAnimateText)
                        .isHidden(!isAnimateText)
                }
            }
        }
        .onAppear {   
            
            let userDefault = UserDefaults.standard
            
            // Full Name
            if (userDefault.value(forKey: "admin_fullName") == nil) {
                userDefault.setValue("Akhil Talashi", forKey: "admin_fullName")
            }
            
            // Date of Birth
            if (userDefault.value(forKey: "admin_dob") == nil) {
                userDefault.setValue("1995-10-06", forKey: "admin_dob")
            }
            
            // Phone Number
            if (userDefault.value(forKey: "admin_phoneNumber") == nil) {
                userDefault.setValue("8576939855", forKey: "admin_phoneNumber")
            }
            
            // Email
            if (userDefault.value(forKey: "admin_email") == nil) {
                userDefault.setValue("akhil@gmail.com", forKey: "admin_email")
            }
            
            // Password
            if (userDefault.value(forKey: "admin_password") == nil) {
                userDefault.setValue("Akhil@123", forKey: "admin_password")
            }
            
            // Image file name
            if (userDefault.value(forKey: "admin_timeStamp") == nil) {
                userDefault.setValue("admin", forKey: "admin_timeStamp")
            }
            
            userDefault.synchronize()
            
            // Animate Text
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    self.isAnimateText = true
                }
            }
            
            // Make View visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isHomeViewActive = true
                }
            }
        }
    }
    
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
