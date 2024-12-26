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
    
    // Manuel olarak Link nesnesi oluşturmak için bir init ekleyin
    init(id: String, title: String, destination: String, shortUrl: String) {
        self.id = id
        self.title = title
        self.destination = destination
        self.shortUrl = shortUrl
    }
}
