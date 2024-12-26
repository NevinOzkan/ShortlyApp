//
//  HistoryVC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit
import SwiftData

class HistoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var links: [Link] = []
    private let viewModel = LinkListViewModel()
    private var container: ModelContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.container
    }
    var shortenedUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchLinks()
        
        if let shortenedUrl = shortenedUrl {
            let mockLink = Link(id: UUID().uuidString, title: "Shortened URL", destination: shortenedUrl, shortUrl: shortenedUrl)
            addLink(mockLink)
        }
        
        tableView.reloadData()
    }
    
    func addLink(_ link: Link) {
        links.append(link)
        tableView.reloadData()
        
        saveLink(id: link.id, shortURL: link.shortUrl, longURL: link.destination)
    }
    
    func saveLink(id: String, shortURL: String, longURL: String) {
        guard let container = container else { return }
        
        let context = container.mainContext
        
        do {
            let newLink = ShortLink(id: id, shortURL: shortURL, longURL: longURL)
            context.insert(newLink)
            try context.save()
            print("Link successfully saved: \(shortURL)")
        } catch {
            print("Error saving link: \(error)")
        }
    }
    
    func fetchLinks() {
        guard let container = container else {
            print("Container not found")
            return
        }
        
        let context = container.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<ShortLink>()
            let savedLinks = try context.fetch(fetchDescriptor)
            
            links = savedLinks.map {
                Link(
                    id: $0.id,
                    title: "Saved Link",
                    destination: $0.longURL,
                    shortUrl: $0.shortURL
                )
            }
            
            print("Fetched links: \(links)")
            tableView.reloadData()
        } catch {
            print("Error fetching links: \(error)")
        }
    }
    
    func deleteLink(at indexPath: IndexPath) {
        let linkToDelete = links[indexPath.row]
        
        guard let container = container else { return }
        let context = container.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<ShortLink>()
            let savedLinks = try context.fetch(fetchDescriptor)
            if let shortLink = savedLinks.first(where: { $0.id == linkToDelete.id }) {
                context.delete(shortLink)
                try context.save()
                print("Link successfully deleted: \(linkToDelete.shortUrl)")
                
                links.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } catch {
            print("Error deleting link: \(error)")
        }
    }
    
    private func setupUI() {
        let nib = UINib(nibName: "ShortLinkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShortLinkCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShortLinkCell", for: indexPath) as? ShortLinkCell else {
            return UITableViewCell()
        }
        
        let link = links[indexPath.row]
        cell.configureCell(with: link)
        
        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            self.deleteLink(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
