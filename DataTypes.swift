//
//  DataTypes.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 7/3/22.
//

import Foundation
import UIKit
import MusicKit
import StoreKit

struct UserTrack: Codable {
//    var id: MusicItemID
    var title: String
    var artist: String
    var count: Int
    var avgPos: Double
}

struct UserAlbum: Codable {
    var title: String
    var artist: String
    var count: Int
}

struct UserArtist: Codable {
    var name: String
    var count: Int
}

struct UserGenre: Codable {
    var name: String
    var count: Int
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
