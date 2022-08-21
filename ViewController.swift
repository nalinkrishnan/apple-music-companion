//
//  ViewController.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 2/28/22.
//
import UIKit
import MusicKit
import StoreKit
import MediaPlayer
import BackgroundTasks


class ViewController: UIViewController {

    @IBAction func GenStatsButton(_ sender: Any) {
        performSegue(withIdentifier: "MainTopSongsSegue", sender: self)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    
        
        Task {
            await LoginManager().requestMusicAuthorization()
            if MusicAuthorization.currentStatus == .authorized {
                
                LaunchManager().retrieveData()
                Task {
                    try await LaunchManager().filterUpdate()
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.current.isSignedIn() {
            AlertService.signIn(in: self) {
                print("Signed In")
            }
        }
    }
}



