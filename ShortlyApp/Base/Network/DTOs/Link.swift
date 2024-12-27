//
//  Link.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import Foundation

struct Link: Codable {
    let id: String
    let title: String
    let destination: String
    let shortUrl: String
    
    
    init(id: String = "", title: String = "", destination: String = "", shortUrl: String) {
        self.id = id
        self.title = title
        self.destination = destination
        self.shortUrl = shortUrl
    }
}
