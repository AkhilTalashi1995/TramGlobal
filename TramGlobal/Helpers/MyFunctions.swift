//
//  Constants.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import Foundation
import SwiftUI

// Save image with desired file name
func saveUserProfile(fileName: String, image: UIImage) {
    do {
        // get the documents directory url
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print("documentsDirectory:", documentsDirectory.path)
        // choose a name for your image
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image.jpegData(compressionQuality:  1) {
            // writes the image data to disk
            try data.write(to: fileURL)
            print("file saved")
        }
    } catch {
        print("error:", error)
    }
}

// Remove image
func removeUserProfile(fileName: String) {
    do {
        // get the documents directory url
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print("documentsDirectory:", documentsDirectory.path)
        // choose a name for your image
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try  FileManager.default.removeItem(at: fileURL)
        print("file removed")
        
    } catch {
        print("error:", error)
    }
}


// Validation
func textFieldValidatorFullName(_ testStr: String) -> Bool {
    let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
    return predicateTest.evaluate(with: testStr)
}

func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // short format
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
}

func textFieldValidatorPhoneNumber(_ string: String) -> Bool {
    guard string.count ==  10 else { return false }
    
    return true
}
