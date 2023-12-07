//
//  UserModel.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import Foundation

class UserModel: Identifiable {
    public var id: Int64 = 0
    public var timeStamp: String = ""
    public var fullName: String = ""
    public var dob: String = ""
    public var phoneNumber: Int64 = 0
    public var email: String = ""
    public var address: String = ""
}
