//
//  ProfileView.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI
import AlertToast

struct ProfileView: View {
    
    // to go back on the home screen when the user is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @AppStorage("isUserLogin") var isUserLogin: Bool?
    
    // create variables to store user input values
    @State var timeStamp: String = ""
    @State var fullName: String = ""
    @State var dob: String = ""
    @State var phoneNumber: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State private var showToast = false
    @State private var image = UIImage()
    @State private var isProfileChanged = false
    @State private var isPhotoPickerPresented = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State var date = Date()
    
    let textFieldWidth = 300.0
    
    var body: some View {
        
        Form {
            Section(header: Text("Admin Profile")) {
                HStack {
                                   Spacer()
                                   userProfileView()
                                       .onTapGesture {
                                           isPhotoPickerPresented = true
                                       }
                                   Spacer()
                               }
                
                
                // Full Name
                TextField("Full Name", text: $fullName, onEditingChanged: {_ in 
                    isProfileChanged = true
                })
                    .frame(width: textFieldWidth)
                    .textInputAutocapitalization(.words)
                
                // Date of Birth
                DatePicker("Date of Birth", selection: $date, displayedComponents: .date)
                
                // Phone Number
                TextField("Phone Number", text: $phoneNumber, onEditingChanged: {_ in
                    isProfileChanged = true
                })
                    .frame(width: textFieldWidth)
                    .keyboardType(.numberPad)
                
                // Email Address
                TextField("Email", text: $email)
                    .foregroundColor(.gray)
                    .frame(width: textFieldWidth)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disabled(true)
                
                // Password
                TextField("Password", text: $password)
                    .foregroundColor(.gray)
                    .frame(width: textFieldWidth)
                    .disabled(true)
                
                // Save Changes
                HStack {
                    Spacer()
                    saveButton()
                    .background(k_app_theme_color)
                    .clipShape(Capsule())
                    Spacer()
                }
            }
            .sheet(isPresented: $isPhotoPickerPresented) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            
        }
        
        .toast(isPresenting: $showToast) {
            AlertToast(type: .regular, title: "Changes saved.")
        }
        
        
        .alert("Alert", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(alertMessage)
        })
        
        .toolbar {
            
            // Logout
            Button {
                isUserLogin = false
                // go back to home page
                
                // Animate Text
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    withAnimation {
                        self.mode.wrappedValue.dismiss()
                    }
                }
                
                
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
            }
        }
//        .tint(k_app_theme_color)
        
        .onAppear() {
            
            let userDefault = UserDefaults.standard
            
            timeStamp = userDefault.value(forKey: "admin_timeStamp") as! String
            fullName = userDefault.value(forKey: "admin_fullName") as! String
            dob = userDefault.value(forKey: "admin_dob") as! String
            
            let isoDate = dob
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDate = dateFormatter.date(from:isoDate)!
            date = newDate
            
            phoneNumber = userDefault.value(forKey: "admin_phoneNumber") as! String
            email = userDefault.value(forKey: "admin_email") as! String
            password = userDefault.value(forKey: "admin_password") as! String
            image =  userProfile(fileName: "\(timeStamp).jpg")
            
        }
//        .navigationTitle("Profile")
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("app_logo")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveButton() -> some View {
        
        ZStack {
            // button to add a user
            Button(action: {
                
                if !textFieldValidatorFullName(self.fullName) {
                    showingAlert.toggle()
                    alertMessage = "Please enter valid name."
                    return
                } else if !textFieldValidatorPhoneNumber(self.phoneNumber) {
                    showingAlert.toggle()
                    alertMessage = "Please enter valid phone number."
                    return
                }
                
                endEditing()
                
                let userDefault = UserDefaults.standard
                dob = date.getDateYYYYMMDD()
                userDefault.setValue(timeStamp, forKey: "admin_timeStamp")
                userDefault.setValue(fullName, forKey: "admin_fullName")
                userDefault.setValue(dob, forKey: "admin_dob")
                userDefault.setValue(phoneNumber, forKey: "admin_phoneNumber")
                userDefault.setValue(email, forKey: "admin_email")
                userDefault.setValue(password, forKey: "admin_password")
                
                saveUserProfile(fileName: "\(self.timeStamp).jpg", image: self.image)
                
                showToast.toggle()
               
            }, label: {
                Text("Save")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
              
            })
        }
        .frame(width: 250, height: 40)
        
    }
    
    
    
    func userProfileView() -> some View {
        ZStack {
            Circle()
                .stroke(k_app_theme_color, lineWidth: 2)
                .background(Circle().fill(.white))
                .frame(width: 100, height: 100)
            
            Image(uiImage: self.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Spacer()
                            ZStack{
                                Circle()
                                    .strokeBorder(.white, lineWidth: 2)
                                    .background(Circle().fill(k_app_theme_color))
                                    .frame(width: 35, height: 35)
                                Button(action: {
                                    // Action for the plus button
                                    // Add your logic here
                                }) {
                                    Image(systemName: "plus")
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.white)
                                }
                            }
                            // Change the color to your preference
                        }
                    }
                )   
        }
        
    }
    
    func userProfile(fileName: String) -> UIImage {
        
        var fileData = Data()
        do {
            // get the documents directory url
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print("documentsDirectory:", documentsDirectory.path)
            // choose a name for your image
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            let data = try Data(contentsOf: fileURL)
            fileData = data
            
        } catch {
            print("error:", error)
        }
        
        return UIImage(data: fileData) ?? UIImage()
    }
    
    
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

#Preview {
    ProfileView()
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
