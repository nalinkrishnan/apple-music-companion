//
//  UpdateData.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 6/3/22.
//

import Foundation
import MusicKit

class DataManager {
    func getLastCall() async -> [String]{
        var lastCall = [String]()
        if let recalledLastCall = UserDefaults.standard.object(forKey: "lastCall") {
            lastCall = recalledLastCall as! [String]
        }
        else {
            UserDefaults.standard.set(lastCall, forKey: "lastCall")
        }
        return lastCall
    }
    
    func updateData(items: [Track]) {
        var currDict = [UserTrack]()
        var currAlbums = [UserAlbum]()
        var currArtists = [UserArtist]()
        var currGenres = [UserGenre]()
        
        if let data = UserDefaults.standard.data(forKey: "userPlays1") {
            do {
                let decoder = JSONDecoder()
                currDict = try decoder.decode([UserTrack].self, from: data)
            } catch {
                print("Unable to Decode Lifetime UserTracks (\(error))")
            }
        }
        
        if let albumData = UserDefaults.standard.data(forKey: "userAlbums") {
            do {
                let decoder = JSONDecoder()
                currAlbums = try decoder.decode([UserAlbum].self, from: albumData)
            } catch {
                print("Unable to Decode Lifetime UserAlbums (\(error))")
            }
        }
        
        if let artistData = UserDefaults.standard.data(forKey: "userArtists") {
            do {
                let decoder = JSONDecoder()
                currArtists = try decoder.decode([UserArtist].self, from: artistData)
            } catch {
                print("Unable to Decode Lifetime UserArtists (\(error))")
            }
        }
        
        if let genreData = UserDefaults.standard.data(forKey: "userGenres") {
            do {
                let decoder = JSONDecoder()
                currGenres = try decoder.decode([UserGenre].self, from: genreData)
            } catch {
                print("Unable to Decode Lifetime UserGenres (\(error))")
            }
        }
        
        var pos:Double = 0
        if currDict.isEmpty {
            for item in items {
                let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                currDict.append(newTrack)
                
                if currAlbums.isEmpty {
                    let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                    currAlbums.append(newAlbum)
                }
                else {
                    for (index, album) in currAlbums.enumerated() {
                        if item.albumTitle == album.title {
                            currAlbums[index].count += 1
                            break
                        }
                        if index == currAlbums.count - 1 {
                            let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                            break
                        }
                    }
                }
                
                if currArtists.isEmpty {
                    let newArtist = UserArtist(name: item.artistName, count: 1)
                    currArtists.append(newArtist)
                }
                else {
                    for (index, artist) in currArtists.enumerated() {
                        if item.artistName == artist.name {
                            currArtists[index].count += 1
                            break
                        }
                        if index == currArtists.count - 1 {
                            let newArtist = UserArtist(name: item.artistName, count: 1)
                            currArtists.append(newArtist)
                            break
                        }
                    }
                }
                
                if currGenres.isEmpty {
                    for genre in item.genreNames {
                        if genre != "Music" {
                            let newGenre = UserGenre(name: genre, count: 1)
                            currGenres.append(newGenre)
                        }
                    }
                }
                else {
                    for genre in item.genreNames {
                        for (index, existingGenre) in currGenres.enumerated() {
                            if existingGenre.name == genre {
                                currGenres[index].count += 1
                                break
                            }
                            if index == currGenres.count - 1 {
                                if genre != "Music" {
                                    let newGenre = UserGenre(name: genre, count: 1)
                                    currGenres.append(newGenre)
                                    break
                                }
                            }
                        }
                    }
                }
                
                pos += 1
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currDict)
                UserDefaults.standard.set(data, forKey: "userPlays1")
            } catch {
                print("Unable to Encode UserTracks (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currAlbums)
                UserDefaults.standard.set(data, forKey: "userAlbums")
            } catch {
                print("Unable to Encode UserAlbums (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currArtists)
                UserDefaults.standard.set(data, forKey: "userArtists")
            } catch {
                print("Unable to Encode UserArtists (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currGenres)
                UserDefaults.standard.set(data, forKey: "userGenres")
            } catch {
                print("Unable to Encode UserGenres (\(error))")
            }
            
            return
        }
        
        //only runs if there is already existing data in userPlays1
        pos = 0
        for item in items {
            for (index, track) in currDict.enumerated() {
                if track.title == item.title && track.artist == item.artistName {
                    currDict[index].count += 1
                    currDict[index].avgPos = ((currDict[index].avgPos * Double((currDict[index].count - 1))) + pos) / Double(currDict[index].count)
                    break
                }
                if index == currDict.count - 1 {
                    let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                    currDict.append(newTrack)
                    break
                }
            }
            
            if currAlbums.isEmpty {
                let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                currAlbums.append(newAlbum)
            }
            else {
                for (index, album) in currAlbums.enumerated() {
                    if album.title == item.albumTitle {
                        currAlbums[index].count += 1
                        break
                    }
                    if index == currAlbums.count - 1 {
                        let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                        break
                    }
                }
            }
            
            if currArtists.isEmpty {
                let newArtist = UserArtist(name: item.artistName, count: 1)
                currArtists.append(newArtist)
            }
            else {
                for (index, artist) in currArtists.enumerated() {
                    if artist.name == item.artistName {
                        currArtists[index].count += 1
                        break
                    }
                    if index == currArtists.count - 1 {
                        let newArtist = UserArtist(name: item.artistName, count: 1)
                        currArtists.append(newArtist)
                        break
                    }
                }
            }
            
            if currGenres.isEmpty {
                for genre in item.genreNames {
                    if genre != "Music" {
                        let newGenre = UserGenre(name: genre, count: 1)
                        currGenres.append(newGenre)
                    }
                }
            }
            else {
                for genre in item.genreNames {
                    for (index, existingGenre) in currGenres.enumerated() {
                        if existingGenre.name == genre {
                            currGenres[index].count += 1
                            break
                        }
                        if index == currGenres.count - 1 {
                            if genre != "Music" {
                                let newGenre = UserGenre(name: genre, count: 1)
                                currGenres.append(newGenre)
                                break
                            }
                        }
                    }
                }
            }
            
            pos += 1
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currDict)
            UserDefaults.standard.set(data, forKey: "userPlays1")
        } catch {
            print("Unable to Encode UserTracks (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currAlbums)
            UserDefaults.standard.set(data, forKey: "userAlbums")
        } catch {
            print("Unable to Encode UserAlbums (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currArtists)
            UserDefaults.standard.set(data, forKey: "userArtists")
        } catch {
            print("Unable to Encode UserArtists (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currGenres)
            UserDefaults.standard.set(data, forKey: "userGenres")
        } catch {
            print("Unable to Encode UserGenres (\(error))")
        }
    }
    
    
    
    
    
    
    
    func weeklyUpdateData(items: [Track]) {
        var currDict = [UserTrack]()
        var currAlbums = [UserAlbum]()
        var currArtists = [UserArtist]()
        var currGenres = [UserGenre]()
        
        if let data = UserDefaults.standard.data(forKey: "weeklyUserPlays" + String(UserDefaults.standard.integer(forKey: "currWeek"))) {
            do {
                let decoder = JSONDecoder()
                currDict = try decoder.decode([UserTrack].self, from: data)
            } catch {
                print("Unable to Decode Weekly UserTracks (\(error))")
            }
        }
        
        if let albumData = UserDefaults.standard.data(forKey: "weeklyUserAlbums" + String(UserDefaults.standard.integer(forKey: "currWeek"))) {
            do {
                let decoder = JSONDecoder()
                currAlbums = try decoder.decode([UserAlbum].self, from: albumData)
            } catch {
                print("Unable to Decode Weekly UserAlbums (\(error))")
            }
        }
        
        if let artistData = UserDefaults.standard.data(forKey: "weeklyUserArtists" + String(UserDefaults.standard.integer(forKey: "currWeek"))) {
            do {
                let decoder = JSONDecoder()
                currArtists = try decoder.decode([UserArtist].self, from: artistData)
            } catch {
                print("Unable to Decode Weekly UserArtists (\(error))")
            }
        }
        
        if let genreData = UserDefaults.standard.data(forKey: "weeklyUserGenres" + String(UserDefaults.standard.integer(forKey: "currWeek"))) {
            do {
                let decoder = JSONDecoder()
                currGenres = try decoder.decode([UserGenre].self, from: genreData)
            } catch {
                print("Unable to Decode Weekly UserGenres (\(error))")
            }
        }
        
        var pos:Double = 0
        if currDict.isEmpty {
            for item in items {
                let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                currDict.append(newTrack)
                
                if currAlbums.isEmpty {
                    let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                    currAlbums.append(newAlbum)
                }
                else {
                    for (index, album) in currAlbums.enumerated() {
                        if item.albumTitle == album.title {
                            currAlbums[index].count += 1
                            break
                        }
                        if index == currAlbums.count - 1 {
                            let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                            break
                        }
                    }
                }
                
                if currArtists.isEmpty {
                    let newArtist = UserArtist(name: item.artistName, count: 1)
                    currArtists.append(newArtist)
                }
                else {
                    for (index, artist) in currArtists.enumerated() {
                        if item.artistName == artist.name {
                            currArtists[index].count += 1
                            break
                        }
                        if index == currArtists.count - 1 {
                            let newArtist = UserArtist(name: item.artistName, count: 1)
                            currArtists.append(newArtist)
                            break
                        }
                    }
                }
                
                if currGenres.isEmpty {
                    for genre in item.genreNames {
                        if genre != "Music" {
                            let newGenre = UserGenre(name: genre, count: 1)
                            currGenres.append(newGenre)
                        }
                    }
                }
                else {
                    for genre in item.genreNames {
                        for (index, existingGenre) in currGenres.enumerated() {
                            if existingGenre.name == genre {
                                currGenres[index].count += 1
                                break
                            }
                            if index == currGenres.count - 1 {
                                if genre != "Music" {
                                    let newGenre = UserGenre(name: genre, count: 1)
                                    currGenres.append(newGenre)
                                    break
                                }
                            }
                        }
                    }
                }
                
                pos += 1
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currDict)
                UserDefaults.standard.set(data, forKey: "weeklyUserPlays" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            } catch {
                print("Unable to Encode UserTracks (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currAlbums)
                UserDefaults.standard.set(data, forKey: "weeklyUserAlbums" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            } catch {
                print("Unable to Encode UserAlbums (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currArtists)
                UserDefaults.standard.set(data, forKey: "weeklyUserArtists" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            } catch {
                print("Unable to Encode UserArtists (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currGenres)
                UserDefaults.standard.set(data, forKey: "weeklyUserGenres" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            } catch {
                print("Unable to Encode UserGenres (\(error))")
            }
            
            return
        }
        
        //only runs if there is already existing data in userPlays1
        pos = 0
        for item in items {
            for (index, track) in currDict.enumerated() {
                if track.title == item.title && track.artist == item.artistName {
                    currDict[index].count += 1
                    currDict[index].avgPos = ((currDict[index].avgPos * Double((currDict[index].count - 1))) + pos) / Double(currDict[index].count)
                    break
                }
                if index == currDict.count - 1 {
                    let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                    currDict.append(newTrack)
                    break
                }
            }
            
            if currAlbums.isEmpty {
                let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                currAlbums.append(newAlbum)
            }
            else {
                for (index, album) in currAlbums.enumerated() {
                    if album.title == item.albumTitle {
                        currAlbums[index].count += 1
                        break
                    }
                    if index == currAlbums.count - 1 {
                        let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                        break
                    }
                }
            }
            
            if currArtists.isEmpty {
                let newArtist = UserArtist(name: item.artistName, count: 1)
                currArtists.append(newArtist)
            }
            else {
                for (index, artist) in currArtists.enumerated() {
                    if artist.name == item.artistName {
                        currArtists[index].count += 1
                        break
                    }
                    if index == currArtists.count - 1 {
                        let newArtist = UserArtist(name: item.artistName, count: 1)
                        currArtists.append(newArtist)
                        break
                    }
                }
            }
            
            if currGenres.isEmpty {
                for genre in item.genreNames {
                    if genre != "Music" {
                        let newGenre = UserGenre(name: genre, count: 1)
                        currGenres.append(newGenre)
                    }
                }
            }
            else {
                for genre in item.genreNames {
                    for (index, existingGenre) in currGenres.enumerated() {
                        if existingGenre.name == genre {
                            currGenres[index].count += 1
                            break
                        }
                        if index == currGenres.count - 1 {
                            if genre != "Music" {
                                let newGenre = UserGenre(name: genre, count: 1)
                                currGenres.append(newGenre)
                                break
                            }
                        }
                    }
                }
            }
            
            pos += 1
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currDict)
            UserDefaults.standard.set(data, forKey: "weeklyUserPlays" + String(UserDefaults.standard.integer(forKey: "currWeek")))
        } catch {
            print("Unable to Encode UserTracks (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currAlbums)
            UserDefaults.standard.set(data, forKey: "weeklyUserAlbums" + String(UserDefaults.standard.integer(forKey: "currWeek")))
        } catch {
            print("Unable to Encode UserAlbums (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currArtists)
            UserDefaults.standard.set(data, forKey: "weeklyUserArtists" + String(UserDefaults.standard.integer(forKey: "currWeek")))
        } catch {
            print("Unable to Encode UserArtists (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currGenres)
            UserDefaults.standard.set(data, forKey: "weeklyUserGenres" + String(UserDefaults.standard.integer(forKey: "currWeek")))
        } catch {
            print("Unable to Encode UserGenres (\(error))")
        }
    }
    
    
    
    
    
    func monthlyUpdateData(items: [Track]) {
        var currDict = [UserTrack]()
        var currAlbums = [UserAlbum]()
        var currArtists = [UserArtist]()
        var currGenres = [UserGenre]()
        
        if let data = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserPlays") {
            do {
                let decoder = JSONDecoder()
                currDict = try decoder.decode([UserTrack].self, from: data)
            } catch {
                print("Unable to Decode Monthly UserTracks (\(error))")
            }
        }
        
        if let albumData = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserAlbums") {
            do {
                let decoder = JSONDecoder()
                currAlbums = try decoder.decode([UserAlbum].self, from: albumData)
            } catch {
                print("Unable to Decode Monthly UserAlbums (\(error))")
            }
        }
        
        if let artistData = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserArtists") {
            do {
                let decoder = JSONDecoder()
                currArtists = try decoder.decode([UserArtist].self, from: artistData)
            } catch {
                print("Unable to Decode Montly UserArtists (\(error))")
            }
        }
        
        if let genreData = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserGenres") {
            do {
                let decoder = JSONDecoder()
                currGenres = try decoder.decode([UserGenre].self, from: genreData)
            } catch {
                print("Unable to Decode Monthly UserGenres (\(error))")
            }
        }
        
        var pos:Double = 0
        if currDict.isEmpty {
            for item in items {
                let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                currDict.append(newTrack)
                
                if currAlbums.isEmpty {
                    let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                    currAlbums.append(newAlbum)
                }
                else {
                    for (index, album) in currAlbums.enumerated() {
                        if item.albumTitle == album.title {
                            currAlbums[index].count += 1
                            break
                        }
                        if index == currAlbums.count - 1 {
                            let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                            break
                        }
                    }
                }
                
                if currArtists.isEmpty {
                    let newArtist = UserArtist(name: item.artistName, count: 1)
                    currArtists.append(newArtist)
                }
                else {
                    for (index, artist) in currArtists.enumerated() {
                        if item.artistName == artist.name {
                            currArtists[index].count += 1
                            break
                        }
                        if index == currArtists.count - 1 {
                            let newArtist = UserArtist(name: item.artistName, count: 1)
                            currArtists.append(newArtist)
                            break
                        }
                    }
                }
                
                if currGenres.isEmpty {
                    for genre in item.genreNames {
                        if genre != "Music" {
                            let newGenre = UserGenre(name: genre, count: 1)
                            currGenres.append(newGenre)
                        }
                    }
                }
                else {
                    for genre in item.genreNames {
                        for (index, existingGenre) in currGenres.enumerated() {
                            if existingGenre.name == genre {
                                currGenres[index].count += 1
                                break
                            }
                            if index == currGenres.count - 1 {
                                if genre != "Music" {
                                    let newGenre = UserGenre(name: genre, count: 1)
                                    currGenres.append(newGenre)
                                    break
                                }
                            }
                        }
                    }
                }
                
                pos += 1
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currDict)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserPlays")
            } catch {
                print("Unable to Encode UserTracks (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currAlbums)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserAlbums")
            } catch {
                print("Unable to Encode UserAlbums (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currArtists)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserArtists")
            } catch {
                print("Unable to Encode UserArtists (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currGenres)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserGenres")
            } catch {
                print("Unable to Encode UserGenres (\(error))")
            }
            
            return
        }
        
        //only runs if there is already existing data in userPlays1
        pos = 0
        for item in items {
            for (index, track) in currDict.enumerated() {
                if track.title == item.title && track.artist == item.artistName {
                    currDict[index].count += 1
                    currDict[index].avgPos = ((currDict[index].avgPos * Double((currDict[index].count - 1))) + pos) / Double(currDict[index].count)
                    break
                }
                if index == currDict.count - 1 {
                    let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                    currDict.append(newTrack)
                    break
                }
            }
            
            if currAlbums.isEmpty {
                let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                currAlbums.append(newAlbum)
            }
            else {
                for (index, album) in currAlbums.enumerated() {
                    if album.title == item.albumTitle {
                        currAlbums[index].count += 1
                        break
                    }
                    if index == currAlbums.count - 1 {
                        let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                        break
                    }
                }
            }
            
            if currArtists.isEmpty {
                let newArtist = UserArtist(name: item.artistName, count: 1)
                currArtists.append(newArtist)
            }
            else {
                for (index, artist) in currArtists.enumerated() {
                    if artist.name == item.artistName {
                        currArtists[index].count += 1
                        break
                    }
                    if index == currArtists.count - 1 {
                        let newArtist = UserArtist(name: item.artistName, count: 1)
                        currArtists.append(newArtist)
                        break
                    }
                }
            }
            
            if currGenres.isEmpty {
                for genre in item.genreNames {
                    if genre != "Music" {
                        let newGenre = UserGenre(name: genre, count: 1)
                        currGenres.append(newGenre)
                    }
                }
            }
            else {
                for genre in item.genreNames {
                    for (index, existingGenre) in currGenres.enumerated() {
                        if existingGenre.name == genre {
                            currGenres[index].count += 1
                            break
                        }
                        if index == currGenres.count - 1 {
                            if genre != "Music" {
                                let newGenre = UserGenre(name: genre, count: 1)
                                currGenres.append(newGenre)
                                break
                            }
                        }
                    }
                }
            }
            
            pos += 1
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currDict)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserPlays")
        } catch {
            print("Unable to Encode UserTracks (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currAlbums)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserAlbums")
        } catch {
            print("Unable to Encode UserAlbums (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currArtists)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserArtists")
        } catch {
            print("Unable to Encode UserArtists (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currGenres)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserGenres")
        } catch {
            print("Unable to Encode UserGenres (\(error))")
        }
    }
    
    
    
    func annualUpdateData(items: [Track]) {
        var currDict = [UserTrack]()
        var currAlbums = [UserAlbum]()
        var currArtists = [UserArtist]()
        var currGenres = [UserGenre]()
        
        if let data = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserPlays") {
            do {
                let decoder = JSONDecoder()
                currDict = try decoder.decode([UserTrack].self, from: data)
            } catch {
                print("Unable to Decode Annual UserTracks (\(error))")
            }
        }
        
        if let albumData = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserAlbums") {
            do {
                let decoder = JSONDecoder()
                currAlbums = try decoder.decode([UserAlbum].self, from: albumData)
            } catch {
                print("Unable to Decode Annual UserAlbums (\(error))")
            }
        }
        
        if let artistData = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserArtists") {
            do {
                let decoder = JSONDecoder()
                currArtists = try decoder.decode([UserArtist].self, from: artistData)
            } catch {
                print("Unable to Decode Annual UserArtists (\(error))")
            }
        }
        
        if let genreData = UserDefaults.standard.data(forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserGenres") {
            do {
                let decoder = JSONDecoder()
                currGenres = try decoder.decode([UserGenre].self, from: genreData)
            } catch {
                print("Unable to Decode Annual UserGenres (\(error))")
            }
        }
        
        var pos:Double = 0
        if currDict.isEmpty {
            for item in items {
                let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                currDict.append(newTrack)
                
                if currAlbums.isEmpty {
                    let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                    currAlbums.append(newAlbum)
                }
                else {
                    for (index, album) in currAlbums.enumerated() {
                        if item.albumTitle == album.title {
                            currAlbums[index].count += 1
                            break
                        }
                        if index == currAlbums.count - 1 {
                            let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                            break
                        }
                    }
                }
                
                if currArtists.isEmpty {
                    let newArtist = UserArtist(name: item.artistName, count: 1)
                    currArtists.append(newArtist)
                }
                else {
                    for (index, artist) in currArtists.enumerated() {
                        if item.artistName == artist.name {
                            currArtists[index].count += 1
                            break
                        }
                        if index == currArtists.count - 1 {
                            let newArtist = UserArtist(name: item.artistName, count: 1)
                            currArtists.append(newArtist)
                            break
                        }
                    }
                }
                
                if currGenres.isEmpty {
                    for genre in item.genreNames {
                        if genre != "Music" {
                            let newGenre = UserGenre(name: genre, count: 1)
                            currGenres.append(newGenre)
                        }
                    }
                }
                else {
                    for genre in item.genreNames {
                        for (index, existingGenre) in currGenres.enumerated() {
                            if existingGenre.name == genre {
                                currGenres[index].count += 1
                                break
                            }
                            if index == currGenres.count - 1 {
                                if genre != "Music" {
                                    let newGenre = UserGenre(name: genre, count: 1)
                                    currGenres.append(newGenre)
                                    break
                                }
                            }
                        }
                    }
                }
                
                pos += 1
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currDict)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserPlays")
            } catch {
                print("Unable to Encode UserTracks (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currAlbums)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserAlbums")
            } catch {
                print("Unable to Encode UserAlbums (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currArtists)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserArtists")
            } catch {
                print("Unable to Encode UserArtists (\(error))")
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currGenres)
                UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserGenres")
            } catch {
                print("Unable to Encode UserGenres (\(error))")
            }
            
            return
        }
        
        //only runs if there is already existing data in userPlays1
        pos = 0
        for item in items {
            for (index, track) in currDict.enumerated() {
                if track.title == item.title && track.artist == item.artistName {
                    currDict[index].count += 1
                    currDict[index].avgPos = ((currDict[index].avgPos * Double((currDict[index].count - 1))) + pos) / Double(currDict[index].count)
                    break
                }
                if index == currDict.count - 1 {
                    let newTrack = UserTrack(title: item.title, artist: item.artistName, count: 1, avgPos: pos)
                    currDict.append(newTrack)
                    break
                }
            }
            
            if currAlbums.isEmpty {
                let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                currAlbums.append(newAlbum)
            }
            else {
                for (index, album) in currAlbums.enumerated() {
                    if album.title == item.albumTitle {
                        currAlbums[index].count += 1
                        break
                    }
                    if index == currAlbums.count - 1 {
                        let newAlbum = UserAlbum(title: item.albumTitle ?? item.title, artist: item.artistName, count: 1)
                            currAlbums.append(newAlbum)
                        break
                    }
                }
            }
            
            if currArtists.isEmpty {
                let newArtist = UserArtist(name: item.artistName, count: 1)
                currArtists.append(newArtist)
            }
            else {
                for (index, artist) in currArtists.enumerated() {
                    if artist.name == item.artistName {
                        currArtists[index].count += 1
                        break
                    }
                    if index == currArtists.count - 1 {
                        let newArtist = UserArtist(name: item.artistName, count: 1)
                        currArtists.append(newArtist)
                        break
                    }
                }
            }
            
            if currGenres.isEmpty {
                for genre in item.genreNames {
                    if genre != "Music" {
                        let newGenre = UserGenre(name: genre, count: 1)
                        currGenres.append(newGenre)
                    }
                }
            }
            else {
                for genre in item.genreNames {
                    for (index, existingGenre) in currGenres.enumerated() {
                        if existingGenre.name == genre {
                            currGenres[index].count += 1
                            break
                        }
                        if index == currGenres.count - 1 {
                            if genre != "Music" {
                                let newGenre = UserGenre(name: genre, count: 1)
                                currGenres.append(newGenre)
                                break
                            }
                        }
                    }
                }
            }
            
            pos += 1
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currDict)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserPlays")
        } catch {
            print("Unable to Encode UserTracks (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currAlbums)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserAlbums")
        } catch {
            print("Unable to Encode UserAlbums (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currArtists)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserArtists")
        } catch {
            print("Unable to Encode UserArtists (\(error))")
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currGenres)
            UserDefaults.standard.set(data, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserGenres")
        } catch {
            print("Unable to Encode UserGenres (\(error))")
        }
    }
    
}
