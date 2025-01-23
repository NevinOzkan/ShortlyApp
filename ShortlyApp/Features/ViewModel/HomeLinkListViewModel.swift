//
//  LinkListViewModel.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import Foundation
import SwiftData

class LinkListViewModel {
    
    var links: [Link] = []
    private let apiService: APIServiceProtocol
    var onLinksUpdated: (([Link]) -> Void)?
    var onError: ((String) -> Void)?
    
    private var container: ModelContainer?
    
    init(apiService: APIServiceProtocol = APIService(), container: ModelContainer?) {
        self.apiService = apiService
        self.container = container
    }
    
    func shortenLink(originalUrl: String, title: String) {
        apiService.createShortenLink(originalUrl: originalUrl, title: title) { [weak self] result in
            switch result {
            case .success(let links):
                if let firstLink = links.first {
                    self?.addLink(firstLink)
                }
            case .failure(let error):
                self?.onError?("Link kısaltılamadı. Hata: \(error.localizedDescription)")
            }
        }
    }
    
    func addLink(_ link: Link) {
        links.append(link)
        onLinksUpdated?(links)
        saveLink(id: link.id, shortURL: link.shortUrl, longURL: link.destination)
    }
    
    func fetchLinks() {
        //Tüm kodun ana iş parçacığında (main thread) çalışmasını sağlar.
        Task { @MainActor in
            guard let container = container else { return }
            let context = container.mainContext
            
            do {
                //Veri sorgulama aracı.
                let fetchDescriptor = FetchDescriptor<ShortLink>()
                let savedLinks = try context.fetch(fetchDescriptor)
                
                links = savedLinks.map { ShortLink in
                    Link(id: ShortLink.id, title: "Saved Link", destination: ShortLink.longURL, shortUrl: ShortLink.shortURL)
                }
                self.onLinksUpdated?(links)
            } catch {
                print("Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func saveLink(id: String, shortURL: String, longURL: String) {
        Task { @MainActor in
            guard let container = container else { return }
            let context = container.mainContext
            
            do {
                let fetchDescriptor = FetchDescriptor<ShortLink>()
                let existingLinks = try context.fetch(fetchDescriptor)
                
                if existingLinks.contains(where: { $0.id == id }) {
                    return
                }
                // Yeni linki veritabanına kaydet.
                let newLink = ShortLink(id: id, shortURL: shortURL, longURL: longURL)
                context.insert(newLink)
                try context.save()
                
                print("Link kaydedildi: \(shortURL)")
            } catch {
                print("Link kayıt edilmedi: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteLink(at indexPath: IndexPath) {
        Task { @MainActor in
            let linkToDelete = links[indexPath.row]
            guard let container = container else { return }
            let context = container.mainContext
            
            do {
                let fetchDescriptor = FetchDescriptor<ShortLink>()
                let savedLinks = try context.fetch(fetchDescriptor)
                
                if let shortLink = savedLinks.first(where: { $0.id == linkToDelete.id }) {
                    context.delete(shortLink)
                    try context.save()
                    
                    links.remove(at: indexPath.row)
                    self.onLinksUpdated?(links)
                }
            } catch {
                print("Error deleting link: \(error.localizedDescription)")
            }
        }
    }
}
