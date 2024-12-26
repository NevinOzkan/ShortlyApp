//
//  LinkListViewModel.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import Foundation
import SwiftData

class LinkListViewModel {
    private var links: [Link] = []
    private let apiService: APIServiceProtocol
    var onLinksUpdated: ((String) -> Void)? 
    var onError: ((String) -> Void)?

    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func shortenLink(originalUrl: String, title: String) {
        apiService.shortenLink(originalUrl: originalUrl, title: title) { [weak self] result in
            switch result {
            case .success(let links):
                if let firstLink = links.first {
                    self?.onLinksUpdated?(firstLink.shortUrl)
                }
            case .failure(let error):
                self?.onError?("Link kısaltılamadı. Hata: \(error.localizedDescription)")
            }
        }
    }
}
