//
//  AddUserView.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI

struct AddUserView: View {
    
    // to go back on the home screen when the user is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // create variables to store user input values
    @State var timeStamp: String = Date().getTimeIntervalShort()
    @State var fullName: String = ""
    @State var dob: String = ""
    @State var phoneNumber: String = ""
    @State var email: String = ""
    @State var address: String = ""
    
    @State private var image = UIImage()
    @State private var isPhotoPickerPresented = false
    @State var date = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""

    let textFieldWidth = 300.0
    var selectedUser: UserModel!
    var isEditMode: Bool!
    
    var body: some View {
        Form {
            Section(header: Text(isEditMode ? "Manage User" : "Add User")) {
                
                
                HStack {
                    Spacer()
                    userProfileView()
                        .onTapGesture {
                            isPhotoPickerPresented = true
                        }
                    Spacer()
                }
                    
                
                
                // User ID
                        TextField("", text: $timeStamp)
//                            .textFieldStyle(.roundedBorder)
                            .frame(width: textFieldWidth)
                            .foregroundColor(.gray)
                            .isHidden(!isEditMode, remove: true)
                            .disabled(true)
                
                // Full Name
                TextField("Full Name", text: $fullName)
                    .frame(width: textFieldWidth)
                    .textInputAutocapitalization(.words)
                
                // Date of Birth
                DatePicker("Date of Birth", selection: $date, displayedComponents: .date)
                
                // Phone Number
                TextField("Phone Number", text: $phoneNumber)
                    .frame(width: textFieldWidth)
                    .keyboardType(.numberPad)
                
                // Email Address
                TextField("Email", text: $email)
                    .frame(width: textFieldWidth)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                // Mailing Address
                TextField("Mailing Address", text: $address, axis: .vertical)
                    .frame(width: textFieldWidth)
                    .lineLimit(3)
                
                HStack {
                    Spacer()
                    submitButton()
                    .background(k_app_theme_color)
                    .clipShape(Capsule())
                    Spacer()
                }
            }

            .sheet(isPresented: $isPhotoPickerPresented) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
        }
        
        
//        .tint(k_app_theme_color)
        
        .alert("Alert", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(alertMessage)
        })
        
        .onAppear() {
            if isEditMode {
                timeStamp = selectedUser.timeStamp
                fullName = selectedUser.fullName
                dob = selectedUser.dob
                phoneNumber = String(selectedUser.phoneNumber)
                email = selectedUser.email
                address = selectedUser.address
                image =  userProfile(fileName: "\(timeStamp).jpg")
                
                let isoDate = dob
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let newDate = dateFormatter.date(from:isoDate)!
                date = newDate
            }
        }
        
        
//        .navigationTitle(isEditMode ? "Manage User" : "Add User")
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("app_logo")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func submitButton() -> some View {
        
        ZStack {
            Button(action: {
                if fullName.isEmpty || phoneNumber.isEmpty || email.isEmpty || address.isEmpty {
                    showingAlert.toggle()
                    alertMessage = "Please fill the missing details."
                    return
                }
                
                if !textFieldValidatorFullName(self.fullName) {
                    showingAlert.toggle()
                    alertMessage = "Please enter valid name."
                    return
                } else if !textFieldValidatorPhoneNumber(self.phoneNumber) {
                    showingAlert.toggle()
                    alertMessage = "Please enter valid phone number."
                    return
                } else if !textFieldValidatorEmail(self.email) {
                    showingAlert.toggle()
                    alertMessage = "Please enter valid email address."
                    return
                }
                
                if isEditMode {
                    
                    let updatedDateStr = date.getDateYYYYMMDD()
                    
                    DB_Manager().updateUser(idValue: selectedUser.id, timeStampValue: self.timeStamp, fullNameValue: self.fullName, dobValue: updatedDateStr, phoneNumberValue: Int64(self.phoneNumber) ?? 0, emailValue: self.email, addressValue: self.address)
                    TramGlobal.saveUserProfile(fileName: "\(self.timeStamp).jpg", image: self.image)
                    
                    // go back to home page
                    self.mode.wrappedValue.dismiss()
                } else {
                    let dateStr = date.getDateYYYYMMDD()
                    
                    DB_Manager().addUser(timeStampValue: timeStamp, fullNameValue: self.fullName, dobValue: dateStr, phoneNumberValue: Int64(self.phoneNumber) ?? 0, emailValue: self.email, addressValue: self.address)
                    TramGlobal.saveUserProfile(fileName: "\(self.timeStamp).jpg", image: self.image)
                    
                    // go back to home page
                    self.mode.wrappedValue.dismiss()
                }
            }, label: {
                
                Text(isEditMode ? "Save" : "Submit")
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
    
//    func saveUserProfile(fileName: String) {
//        do {
//            // get the documents directory url
//            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            print("documentsDirectory:", documentsDirectory.path)
//            // choose a name for your image
//            // create the destination file url to save your image
//            let fileURL = documentsDirectory.appendingPathComponent(fileName)
//            // get your UIImage jpeg data representation and check if the destination file url already exists
//            if let data = self.image.jpegData(compressionQuality:  1) {
//                // writes the image data to disk
//                try data.write(to: fileURL)
//                print("file saved")
//            }
//        } catch {
//            print("error:", error)
//        }
//    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddUserView()
}
