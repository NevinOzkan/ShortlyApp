//
//  LinkListViewModel.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import Foundation

class LinkListViewModel {

    private var links: [Link] = []
    private let apiService: APIServiceProtocol
    var onLinksUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    var numberOfLinks: Int {
        return links.count
    }
    
    func link(at index: Int) -> Link {
        return links[index]
    }
    
    func shortenLink(originalUrl: String, title: String, completion: @escaping (Bool) -> Void) {
        apiService.shortenLink(originalUrl: originalUrl, title: title) { [weak self] result in
            switch result {
            case .success(let links):
                if let firstLink = links.first {
                    print("Kısa Link: \(firstLink.shortUrl)")
                }
                self?.onLinksUpdated?()
                completion(true)
            case .failure(let error):
                self?.onError?("Link kısaltılamadı. Hata: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
