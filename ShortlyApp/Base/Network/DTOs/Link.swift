//
//  Link.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import Foundation

struct Link: Decodable {
    let id: String
    let title: String
    let slashtag: String
    let destination: String
    let createdAt: String
    let updatedAt: String
    let expiredAt: String?
    let status: String
    let tags: [String]
    let linkType: String
    let clicks: Int
    let isPublic: Bool
    let shortUrl: String
    let domainId: String
    let domainName: String
    let https: Bool
    let favourite: Bool
}
