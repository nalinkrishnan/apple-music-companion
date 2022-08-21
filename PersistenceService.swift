//
//  PersistenceService.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 7/20/22.
//

import Foundation

class PersistenceService {
    
    private init() {}
    
    static let shared = PersistenceService()
    let userDefaults = UserDefaults.standard
    
    
}
