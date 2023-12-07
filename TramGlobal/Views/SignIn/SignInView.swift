//
//  SignIn.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI
import AlertToast

struct SignInView: View {
    
    @AppStorage("isUserLogin") var isUserLogin: Bool?
    
    @State var showLoginView: Bool = false
    @State var isLinkActive = false
    
    @State private var showToast = false
    @State private var isLoginSuccess = false
    
    @State var emailAddress: String = "" //"akhil@gmail.com"
    @State var password: String = "" //Akhil@123"
    
    let textFieldWidth = 300.0
    
    var body: some View {
        NavigationView {
            VStack {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .padding(.top, -150)
                
                Text("Sign In")
                    .font(.largeTitle)
                    .padding(.bottom, 50)
                
                TextField("Email", text: $emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: textFieldWidth)
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                HybridTextField(text: $password, titleKey: "Password")
                    .frame(width: textFieldWidth, alignment: .leading)
                    .padding(.bottom, 20)
                
                Button(action: {
                    let userDefault = UserDefaults.standard
                    let admingEmail = userDefault.value(forKey: "admin_email") as! String
                    let admingPassword = userDefault.value(forKey: "admin_password") as! String
                    
                    if (emailAddress.caseInsensitiveCompare(admingEmail) == .orderedSame && password == admingPassword) {
                        isUserLogin = true
                        isLoginSuccess = true
                    } else {
                        isLoginSuccess = false
                    }
                    showToast.toggle()
                    
                }, label: {
                    Text("Sign In")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 40)
                    
                })
                .background(k_app_theme_color)
                .clipShape(Capsule())
            }
        }
        
        
        .toast(isPresenting: $showToast) {
            
            if isLoginSuccess {
                AlertToast(type: .regular, title: "Success!")
            } else {
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "Invalid credentials")
            }
            
            // `.alert` is the default displayMode
            //                    AlertToast(type: .regular, title: "Message Sent!")
            
            //Choose .hud to toast alert from the top of the screen
            //AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
            
            //Choose .banner to slide/pop alert from the bottom of the screen
            
        }
    }
}

///Contains all the code for the Secure and regular TextFields
struct HybridTextField: View {
    
    @Binding var text: String
    @State var isSecure: Bool = true
    
    var titleKey: String
    
    var body: some View {
        HStack{
            Group{
                if isSecure{
                    SecureField(titleKey, text: $text)
                    
                }else{
                    TextField(titleKey, text: $text)
                }
            }.textFieldStyle(.roundedBorder)
                .animation(.easeInOut(duration: 0.2), value: isSecure)
                .frame(width: 300)
            //Add any common modifiers here so they dont have to be repeated for each Field
            
            
            
            Button(action: {
                isSecure.toggle()
            }, label: {
                Image(systemName: !isSecure ? "eye.slash" : "eye" )
            })
            .frame(alignment: .trailing)
            .offset(x: -50.0)
        }//Add any modifiers shared by the Button and the Fields here
    }
}

#Preview {
    SignInView()
}
