//
//  ShortLink.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 24.12.2024.
//

import SwiftData

@Model
class ShortLink {
    @Attribute(.unique) var id: String
    var shortURL: String
    var longURL: String
    
    init(id: String, shortURL: String, longURL: String) {
        self.id = id
        self.shortURL = shortURL
        self.longURL = longURL
    }
}
