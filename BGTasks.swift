//
//  BGTasks.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 7/5/22.
//

import Foundation
import UIKit
import MusicKit
import BackgroundTasks

final class RefreshAppContentsOperation: Operation {
    
    override func main() {
        guard !isCancelled else {return}
        print("fetching new data...")
        LaunchManager().retrieveData()
        Task {
            try await LaunchManager().filterUpdate()
        }
    }
    
}
