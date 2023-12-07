//
//  SQLiteDBManager.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import Foundation
import SQLite

class DB_Manager {
    
    // sqlite instance
    private var db: Connection!
    
    // table instance
    private var users: Table!
    
    // columns instances of table
    private var id: Expression<Int64>!
    private var timeStamp: Expression<String>!
    private var fullName: Expression<String>!
    private var dob: Expression<String>!
    private var phoneNumber: Expression<Int64>!
    private var email: Expression<String>!
    private var address: Expression<String>!
    
    // constructor of this class
    init () {
        
        // exception handling
        do {
            
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            print("Database path..\(path)")
            
            // creating database connection
            db = try Connection("\(path)/myUsers.sqlite3")
            
            // creating table object
            users = Table("users")
            
            // create instances of each column
            id = Expression<Int64>("id")
            timeStamp = Expression<String>("timeStamp")
            fullName = Expression<String>("fullName")
            dob = Expression<String>("dob")
            phoneNumber = Expression<Int64>("phoneNumber")
            email = Expression<String>("email")
            address = Expression<String>("address")
            
            // check if the user's table is already created
            if (!UserDefaults.standard.bool(forKey: "isDbCreated")) {
                
                // if not, then create the table
                try db.run(users.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(timeStamp)
                    t.column(fullName)
                    t.column(dob)
                    t.column(phoneNumber)
                    t.column(email, unique: true)
                    t.column(address)
                })
                
                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "isDbCreated")
            } else {
                print("DB already created.")
            }
            
        } catch {
            // show error message if any
            print(error.localizedDescription)
        }
        
    }
    
    // Add user
    public func addUser(timeStampValue: String, fullNameValue: String, dobValue: String, phoneNumberValue: Int64, emailValue: String, addressValue: String) {
        do {
            try db.run(users.insert(timeStamp <- timeStampValue, fullName <- fullNameValue, dob <- dobValue, phoneNumber <- phoneNumberValue, email <- emailValue, address <- addressValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Get users
    public func getUsers() -> [UserModel] {
        
        // create empty array
        var userModels: [UserModel] = []
        
        // get all users in descending order
        users = users.order(fullName.asc)
        
        // exception handling
        do {
            
            // loop through all users
            for user in try db.prepare(users) {
                
                // create new model in each loop iteration
                let userModel: UserModel = UserModel()
                
                // set values in model from database
                userModel.id = user[id]
                userModel.timeStamp = user[timeStamp]
                userModel.fullName = user[fullName]
                userModel.dob = user[dob]
                userModel.phoneNumber = user[phoneNumber]
                userModel.email = user[email]
                userModel.address = user[address]
                
                // append in new array
                userModels.append(userModel)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // return array
        return userModels
    }
    
    // Update user
    public func updateUser(idValue: Int64, timeStampValue: String, fullNameValue: String, dobValue: String, phoneNumberValue: Int64, emailValue: String, addressValue: String) {
        do {
            // get user using ID
            let user: Table = users.filter(id == idValue)
             
            // run the update query
            try db.run(user.update(timeStamp <- timeStampValue, fullName <- fullNameValue, dob <- dobValue, phoneNumber <- phoneNumberValue, email <- emailValue, address <- addressValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Delete user
    public func deleteUser(idValue: Int64) {
        do {
            // get user using ID
            let user: Table = users.filter(id == idValue)
            
            // run the delete query
            try db.run(user.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}
