//
//  Launch.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 7/3/22.
//

import Foundation
import UIKit
import MusicKit
import StoreKit

class LaunchManager {
    func incrementWeeklyContainer() {
        var currWeek = UserDefaults.standard.integer(forKey: "currWeek")
        currWeek = currWeek + 1
        UserDefaults.standard.set(currWeek, forKey: "currWeek")
    }
    
    func incrementMonthlyContainer() {
        let date = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        let currMonth = monthFormatter.string(from: date)
        UserDefaults.standard.set(currMonth, forKey: "currMonth")
    }
    
    func incrementAnnualContainer() {
        let date = Date()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let currYear = yearFormatter.string(from: date)
        UserDefaults.standard.set(currYear, forKey: "currYear")
    }
    
    func retrieveData() {
        var userPlays = Data()
        let weeklyUserPlays = Data()
        let monthlyUserPlays = Data()
        let annualUserPlays = Data()
        if let recalledUserPlays = UserDefaults.standard.object(forKey: "userPlays1") {
            userPlays = recalledUserPlays as! Data
            //if it's Sunday, start a new persistent array
            let date = Date()
            if date.dayNumberOfWeek() == 1 {
                incrementWeeklyContainer()
                UserDefaults.standard.set(weeklyUserPlays, forKey: "weeklyUserPlays" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date)
            let dayOfMonth = components.day
            if dayOfMonth == 1 {
                incrementMonthlyContainer()
                UserDefaults.standard.set(monthlyUserPlays, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserPlays")
                if UserDefaults.standard.string(forKey: "currMonth")! == "January" {
                    incrementAnnualContainer()
                    UserDefaults.standard.set(annualUserPlays, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserPlays")
                }
            }
        }
        else {
            UserDefaults.standard.set(userPlays, forKey: "userPlays1")
            //first time user opening application
            let currWeek = 0
            UserDefaults.standard.set(currWeek, forKey: "currWeek")
            UserDefaults.standard.set(weeklyUserPlays, forKey: "weeklyUserPlays" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            
            let date = Date()
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "LLLL"
            let currMonth = monthFormatter.string(from: date)
            UserDefaults.standard.set(currMonth, forKey: "currMonth")
            UserDefaults.standard.set(monthlyUserPlays, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserPlays")
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            let currYear = yearFormatter.string(from: date)
            UserDefaults.standard.set(currYear, forKey: "currYear")
            UserDefaults.standard.set(annualUserPlays, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserPlays")
            
        }
        
        var userAlbums = Data()
        let weeklyUserAlbums = Data()
        let monthlyUserAlbums = Data()
        let annualUserAlbums = Data()
        if let recalledUserAlbums = UserDefaults.standard.object(forKey: "userAlbums") {
            userAlbums = recalledUserAlbums as! Data
            
            let date = Date()
            if date.dayNumberOfWeek() == 1 {
                UserDefaults.standard.set(weeklyUserAlbums, forKey: "weeklyUserAlbums" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date)
            let dayOfMonth = components.day
            if dayOfMonth == 1 {
                UserDefaults.standard.set(monthlyUserAlbums, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserAlbums")
                if UserDefaults.standard.string(forKey: "currMonth")! == "January" {
                    UserDefaults.standard.set(annualUserAlbums, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserAlbums")
                }
            }
        }
        else {
            //first time opening application
            UserDefaults.standard.set(userAlbums, forKey: "userAlbums")
            UserDefaults.standard.set(weeklyUserAlbums, forKey: "weeklyUserAlbums" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            UserDefaults.standard.set(monthlyUserAlbums, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserAlbums")
            UserDefaults.standard.set(annualUserAlbums, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserAlbums")
        }
        
        var userArtists = Data()
        let weeklyUserArtists = Data()
        let monthlyUserArtists = Data()
        let annualUserArtists = Data()
        if let recalledUserArtists = UserDefaults.standard.object(forKey: "userArtists") {
            userArtists = recalledUserArtists as! Data
            let date = Date()
            if date.dayNumberOfWeek() == 1 {
                UserDefaults.standard.set(weeklyUserArtists, forKey: "weeklyUserArtists" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date)
            let dayOfMonth = components.day
            if dayOfMonth == 1 {
                UserDefaults.standard.set(monthlyUserArtists, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserArtists")
                if UserDefaults.standard.string(forKey: "currMonth")! == "January" {
                    UserDefaults.standard.set(annualUserArtists, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserArtists")
                }
            }
        }
        else {
            UserDefaults.standard.set(userArtists, forKey: "userArtists")
            UserDefaults.standard.set(weeklyUserArtists, forKey: "weeklyUserArtists" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            UserDefaults.standard.set(monthlyUserArtists, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserArtists")
            UserDefaults.standard.set(annualUserArtists, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserArtists")
        }
        
        var userGenres = Data()
        let weeklyUserGenres = Data()
        let monthlyUserGenres = Data()
        let annualUserGenres = Data()
        if let recalledUserGenres = UserDefaults.standard.object(forKey: "userGenres") {
            userGenres = recalledUserGenres as! Data
            let date = Date()
            if date.dayNumberOfWeek() == 1 {
                UserDefaults.standard.set(weeklyUserGenres, forKey: "weeklyUserGenres" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date)
            let dayOfMonth = components.day
            if dayOfMonth == 1 {
                UserDefaults.standard.set(monthlyUserGenres, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserGenres")
                if UserDefaults.standard.string(forKey: "currMonth")! == "January" {
                    UserDefaults.standard.set(annualUserGenres, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserGenres")
                }
            }
        }
        else {
            UserDefaults.standard.set(userGenres, forKey: "userGenres")
            UserDefaults.standard.set(weeklyUserGenres, forKey: "weeklyUserGenres" + String(UserDefaults.standard.integer(forKey: "currWeek")))
            UserDefaults.standard.set(monthlyUserGenres, forKey: (UserDefaults.standard.string(forKey: "currMonth")!) + "UserGenres")
            UserDefaults.standard.set(annualUserGenres, forKey: (UserDefaults.standard.string(forKey: "currYear")!) + "UserGenres")
        }
        
        
    }
    
    func filterUpdate() async throws {
        let items = try await SoundtrackKit.recentlyPlayedTracks()
        var titles = [String]()
        var itemstoAdd = [Track]()
        for item in items {
            titles.append(item.title)
        }
        //set lastCall variable to return value from getLastCall
        let lastCall = await DataManager().getLastCall()
        if lastCall.isEmpty {
            //first time user has opened application
            UserDefaults.standard.set(titles, forKey: "lastCall")
            
            for item in items {
                itemstoAdd.append(item)
            }
            DataManager().updateData(items: itemstoAdd)
        }
        else {

            var updateIndex = 0
            for (index, item) in items.enumerated() {
                if updateIndex != 0 {
                    break
                }
                if item.title == lastCall[0] {
                    for k in 1...(30 - index - 1) {
                        if items[index + k].title == lastCall[k] {
                            updateIndex = 30 - index - 1
                        }
                        else {
                            updateIndex = 0
                            break
                        }
                    }
                }
            }
            if updateIndex < 29 {
                for i in 0...(30 - updateIndex - 2) {
                    itemstoAdd.append(items[i])
                }
            }
            if !itemstoAdd.isEmpty {
                DataManager().updateData(items: itemstoAdd)
                DataManager().weeklyUpdateData(items: itemstoAdd)
                DataManager().monthlyUpdateData(items: itemstoAdd)
                DataManager().annualUpdateData(items: itemstoAdd)
            }
            UserDefaults.standard.set(titles, forKey: "lastCall")
        }
    }
    
    
}
