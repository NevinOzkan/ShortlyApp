//
//  MockAPIService.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 25.12.2024.
//

import Foundation

class MockAPIService: APIServiceProtocol {
    func shortenLink(originalUrl: String, title: String, completion: @escaping (Result<[Link], Error>) -> Void) {
        let mockLink1 = Link(
            id: UUID().uuidString,
            title: title,
            destination: originalUrl,
            shortUrl: "https://mock.ly/abcd123"
        )
        
        let mockLink2 = Link(
            id: UUID().uuidString,
            title: "\(title) 2",
            destination: originalUrl,
            shortUrl: "https://mock.ly/efgh456"
        )
        
        completion(.success([mockLink1, mockLink2]))
    }
}
