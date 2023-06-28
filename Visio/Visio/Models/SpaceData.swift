//
//  SpaceData.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import Foundation

struct SpaceDataNews: Codable {
    let results: [Data]
}

struct Data: Codable {
    var id: Int
    var title: String?
    var url: String?
    var imageUrl: String?
    var newsSite: String?
    var summary: String?
    var publishedAt: String
}
