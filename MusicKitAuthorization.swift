//
//  MusicKitAuthorization.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 5/5/22.
//

import Foundation
import MusicKit

class LoginManager: ObservableObject {

    func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request();
        switch status {
        case .authorized: print("Access granted.")
        case .denied, .restricted: print("Access denied or restricted.")
        case .notDetermined: print("Access cannot be determined.")
        @unknown default:
                print("error from MusicKitAuthorizationStatus")
        }
    }
}
