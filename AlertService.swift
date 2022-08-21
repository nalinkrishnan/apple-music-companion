//
//  AlertService.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 7/20/22.
//

import Foundation
import UIKit

class AlertService {
    
    private init() {}
    
    static func signIn(in vc: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Sign In", message: nil, preferredStyle: .alert)
        alert.addTextField { (usernameTF) in
            usernameTF.placeholder = "Enter your username"
        }
        
        let signIn = UIAlertAction(title: "Sign In", style: .default) { (_) in
            guard let username = alert.textFields?.first?.text else { return }
            User.current.userName = username
            
            completion()
        }
        alert.addAction(signIn)
        vc.present(alert, animated: true)
    }
}
