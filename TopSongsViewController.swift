//
//  TopSongsViewController.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 6/13/22.
//

import Foundation
import UIKit
import MusicKit
import StoreKit
import MediaPlayer

class TopSongsViewController: UIViewController {
    
    @IBOutlet weak var TopSongsOutlet: UILabel!
    @IBOutlet weak var TopAlbumsOutlet: UILabel!
    @IBOutlet weak var TopArtistsOutlet: UILabel!
    @IBOutlet weak var TopGenresOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortedTracks = StatsGenerator().sortTracks()
        let sortedAlbums = StatsGenerator().sortAlbums()
        let sortedArtists = StatsGenerator().sortArtists()
        let sortedGenres = StatsGenerator().sortGenres()
        TopSongsOutlet.text = StatsGenerator().getTopPlayedTracks(sortedList: sortedTracks)
        TopAlbumsOutlet.text = StatsGenerator().getTopPlayedAlbums(sortedList: sortedAlbums)
        TopArtistsOutlet.text = StatsGenerator().getTopArtists(sortedList: sortedArtists)
        TopGenresOutlet.text = StatsGenerator().getTopGenres(sortedList: sortedGenres)
    
    }
}
