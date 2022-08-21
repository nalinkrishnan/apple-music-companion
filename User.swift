//
//  User.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 7/20/22.
//

import Foundation

class User {
    
    
    var userName = "" {
        didSet {
            UserDefaults.standard.set(userName, forKey: "username")
        }
    }
    
//    var token = "" {
//        didSet {
//            UserDefaults.standard.set(token, forKey: "token")
//        }
//    }
    
    static let current = User()
    
    func signIn() {
        let userDefaults = UserDefaults.standard
        guard let username = userDefaults.string(forKey: "username") else {return}
        
        self.userName = username
    }
    
    func isSignedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil
    }
}
