//
//  ContentView.swift
//  TramGlobal
//
//  Created by Akhil on 02/12/23.
//

import SwiftUI

struct HomeView: View {
    
    // Array of user models
    @State var userModels: [UserModel] = []
    @State private var searchText = ""
    @State var userName = ""
    
    var body: some View {
        
        VStack {
            
            // Info
            VStack(alignment: .leading) {
                HStack {
                    Text("Hello,")
                        .font(.title3)
                        .foregroundStyle(k_app_theme_color)
                    Text("\(userName)!")
                        .font(.title3)
                }
                
                Text("Simplify user management with ease.")
                    .fontWeight(.light)
            }
            .offset(x: -30)
            
            
            ZStack(alignment: .bottomTrailing) {
                    Spacer()
                    List  {
                        
                       userCount()
                            .isHidden(self.userModels.isEmpty, remove: true)
                        
                        ForEach(self.searchResults, id: \.id) { model in
                            
                            NavigationLink {
                                AddUserView(selectedUser: model, isEditMode: true)
                            } label: {
                                HStack {
                                    
                                    userProfile(fileName: "\(model.timeStamp).jpg")
                                    
                                    
                                    VStack(alignment: .leading) {
                                        Text(model.fullName)
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                        
                                        Text(model.email)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    
                                    Text("User ID: \(model.timeStamp)")
                                        .font(.caption)
                                        .fontWeight(.light)
                                    
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
//                }
                
                
                // + Floating button
                VStack {
                    NavigationLink(destination: AddUserView(isEditMode: false)) {
                        
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(k_app_theme_color)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding()

            }
            
            // Message when no users
            .overlay {
                VStack {
                    Text("No Users")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Please add new user from + button.")
                        .font(.body)
                        .fontWeight(.light)
                }
                .padding(.bottom, 50)
                .isHidden(self.userModels.count != 0)
            }
        }
        .searchable(text: $searchText, prompt: "Search Users by Name & Email ID")
        .textInputAutocapitalization(.never)
        
        
//        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("app_logo")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        // load data in user models array
        .onAppear(perform: {
            userName = UserDefaults.standard.value(forKey: "admin_fullName") as! String
            self.userModels = DB_Manager().getUsers()
        })
        
    }
    
    
    var searchResults: [UserModel] {
        if searchText.isEmpty {
            return userModels
        } else {
            return userModels.filter {
                ($0.email.localizedCaseInsensitiveContains(searchText) || $0.fullName.localizedCaseInsensitiveContains(searchText))
            }
        }
    }
    
    func userCount() -> some View {
        return HStack {
            Text("Total Users:")
                .fontWeight(.semibold)
            
            Text("\(self.userModels.count)")
                .foregroundStyle(k_app_theme_color)
                .fontWeight(.semibold)
        }
    }
    
    func userProfile(fileName: String) -> some View {
        
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
        
        return Image(uiImage: UIImage(data: fileData) ?? UIImage()).resizable().frame(width: 45, height: 45).cornerRadius(30)
    }
    
    func delete(at offsets: IndexSet) {
        
        let user = self.userModels[offsets.first!]
        
        self.userModels.remove(atOffsets: offsets)
        
        // create db manager instance
        let dbManager: DB_Manager = DB_Manager()
        
        // call delete function
        dbManager.deleteUser(idValue: user.id)
        
        // refresh the user models array
        self.userModels = dbManager.getUsers()
    }
    
}

#Preview {
    HomeView()
}
