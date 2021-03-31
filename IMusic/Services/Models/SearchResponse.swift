//
//  SearchResponse.swift
//  IMusic
//
//  Created by Платон Конкилов on 05.04.2020.
//  Copyright © 2020 Платон Конкилов. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable  {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
