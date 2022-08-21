//
//  UserMusicitem.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 5/5/22.
//

import MusicKit

/// A collection of user music items.
public typealias UserMusicItems = MusicItemCollection<UserMusicItem>

/// A generic music item that may either contain an album, playlist or a station.
public enum UserMusicItem: Equatable, Hashable, Identifiable {
    case album(Album)
    case playlist(Playlist)
    case station(Station)
    case track(Track)
}

extension UserMusicItem: MusicItem {
    public var id: MusicItemID {
        let id: MusicItemID

        switch self {
            case .album(let album): id = album.id
            case .playlist(let playlist): id = playlist.id
            case .station(let station): id = station.id
            case .track(let track): id = track.id
        }

        return id
    }
}

extension UserMusicItem: Decodable {
    enum CodingKeys: CodingKey {
        case type
    }

    private enum HistoryMusicItemTypes: String, Codable {
        case album = "albums"
        case libraryAlbum = "library-albums"
        case playlist = "playlists"
        case libraryPlaylist = "library-playlists"
        case station = "stations"
        case song = "songs"
        case librarySong = "library-songs"
        case musicVideo = "music-video"
        case libraryMusicVideo = "library-music-video"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(HistoryMusicItemTypes.self, forKey: .type)

        switch type {
            case .album, .libraryAlbum:
                let album = try Album(from: decoder)
                self = .album(album)
            case .playlist, .libraryPlaylist:
                let playlist = try Playlist(from: decoder)
                self = .playlist(playlist)
            case .station:
                let station = try Station(from: decoder)
                self = .station(station)
            case .song, .librarySong, .musicVideo, .libraryMusicVideo:
                let track = try Track(from: decoder)
                self = .track(track)
        }
    }
}

extension UserMusicItem: Encodable {
    public func encode(to encoder: Encoder) throws {
    }
}
