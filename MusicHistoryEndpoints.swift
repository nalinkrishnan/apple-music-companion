//
//  MusicHistoryEndpoints.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 5/5/22.
//

import Foundation

/// Different endpoints related to historial data.
/// Possible types: Heavy rotation, recently added, and recently played resources.
public enum MusicHistoryEndpoints {
    case heavyRotation
    case recentlyAdded
    case recentlyPlayed
    case recentlyPlayedTracks
    case recentlyPlayedStations

    var path: String {
        switch self {
            case .heavyRotation: return "history/heavy-rotation"
            case .recentlyAdded: return "library/recently-added"
            case .recentlyPlayed: return "recent/played"
            case .recentlyPlayedTracks: return "recent/played/tracks"
            case .recentlyPlayedStations: return "recent/radio-stations"
        }
    }
}
