//
//  UserStats.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 6/9/22.
//

import Foundation
import MusicKit

struct Songs: Decodable {
    let data: [Track]
}

class StatsGenerator {
    
    func sortTracks() -> [UserTrack] {
        var list = [UserTrack]()
        if let data = UserDefaults.standard.data(forKey: "userPlays1") {
            do {
                let decoder = JSONDecoder()
                list = try decoder.decode([UserTrack].self, from: data)
            } catch {
                print("Unable to Decode UserTracks (\(error))")
            }
        }
        
        list.sort { $0.count == $1.count ? $0.avgPos < $1.avgPos : $0.count > $1.count }
        return list
    }
    
    func sortAlbums() -> [UserAlbum] {
        var list = [UserAlbum]()
        if let data = UserDefaults.standard.data(forKey: "userAlbums") {
            do {
                let decoder = JSONDecoder()
                list = try decoder.decode([UserAlbum].self, from: data)
            } catch {
                print("Unable to Decode UserAlbums (\(error))")
            }
        }
        
        list.sort { $0.count > $1.count }
        return list
    }
    
    func sortArtists() -> [UserArtist] {
        var list = [UserArtist]()
        if let data = UserDefaults.standard.data(forKey: "userArtists") {
            do {
                let decoder = JSONDecoder()
                list = try decoder.decode([UserArtist].self, from: data)
            } catch {
                print("Unable to Decode UserArtists (\(error))")
            }
        }
        
        list.sort { $0.count > $1.count }
        return list
    }
    
    func sortGenres() -> [UserGenre] {
        var list = [UserGenre]()
        if let data = UserDefaults.standard.data(forKey: "userGenres") {
            do {
                let decoder = JSONDecoder()
                list = try decoder.decode([UserGenre].self, from: data)
            } catch {
                print("Unable to Decode UserGenres (\(error))")
            }
        }
        
        list.sort { $0.count > $1.count }
        return list
    }
    
    func getTopPlayedTracks(sortedList: [UserTrack]) -> String {
        var returnString  = ""
//        for (index, track) in sortedList.enumerated() {
//            do {
//                var songName = String()
//                let trackID = String(describing: track.id)
//                let countryCode = try await MusicDataRequest.currentCountryCode
//                let trackURL = "https://api.music.apple.com/v1/catalog/\(countryCode)/songs/\(trackID)"
//                guard let url = URL(string: trackURL) else {
//                        throw URLError(.badURL)
//                    }
//                let request = MusicDataRequest(urlRequest: URLRequest(url: url))
//                let response = try await request.response()
//                let song = try JSONDecoder().decode(Songs.self, from: response.data)
////                print(song)
//                songName = song.data[0].title
//                returnString += (String(index + 1)) + ": " + songName + "\n"
//                print(index + 1, ": ", songName)
//            } catch {
//                print(error)
//            }
//            if index == 4 {
//                break
//            }
//        }
        for (index, track) in sortedList.enumerated() {
            returnString += (String(index + 1)) + ": " + track.title + "\n"
            print(index + 1, ": ", track.title)
            if index == 4 {
                break
            }
        }
        
        return returnString
    }
    
    func getTopPlayedAlbums(sortedList: [UserAlbum]) -> String {
        var returnString = ""
        
        for (index, album) in sortedList.enumerated() {
            returnString += (String(index + 1)) + ": " + album.title + "\n"
            print(index + 1, ": ", album.title)
            if index == 4 {
                break
            }
        }
    
        return returnString
    }
    
    func getTopArtists(sortedList: [UserArtist]) -> String {
        var returnString = ""

        for (index, artist) in sortedList.enumerated() {
            returnString += (String(index + 1)) + ": " + artist.name + "\n"
            if index == 4 {
                break
            }
        }
    
        return returnString
    }
    
    func getTopGenres(sortedList: [UserGenre]) -> String {
        var returnString = ""
        
        for (index, genre) in sortedList.enumerated() {
            returnString += (String(index + 1)) + ": " + genre.name + "\n"
            if index == 4 {
                break
            }
        }
    
        return returnString
    }
}
