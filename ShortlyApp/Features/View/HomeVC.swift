//
//  HomeVC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit
import SwiftData

class HomeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shortenTextField: UITextField!
    
    var links: [Link] = []
    private var viewModel: LinkListViewModel!
    private var container: ModelContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchLinks()
        
        viewModel = LinkListViewModel(apiService: MockAPIService())
        
        
        imageView.isHidden = false
        textField.isHidden = false
        label.isHidden = false
        tableView.isHidden = true
        shortenTextField.isHidden = false
        titleLabel.isHidden = true
    }
    
    private func setupUI() {
        let nib = UINib(nibName: "ShortLinkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShortLinkCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addLink(_ link: Link) {
        links.append(link)
        tableView.reloadData()
        
        saveLink(id: link.id, shortURL: link.shortUrl, longURL: link.destination)
    }
    
    func fetchLinks() {
        guard let container = container else {
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching links: \(error)")
        }
    }

    func saveLink(id: String, shortURL: String, longURL: String) {
        guard let container = container else { return }
        
        let context = container.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<ShortLink>()
            let existingLinks = try context.fetch(fetchDescriptor)
            if existingLinks.contains(where: { $0.id == id }) {
                print("Bu link zaten kaydedilmiş.")
                return
            }
            
            let newLink = ShortLink(id: id, shortURL: shortURL, longURL: longURL)
            context.insert(newLink)
            try context.save()
            print("Link kaydedildi: \(shortURL)")
        } catch {
            print("Link kayıt edilemedi: \(error)")
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
                
                links.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        } catch {
            print("Error deleting link: \(error)")
        }
    }
    
    @IBAction func shortenButton(_ sender: Any) {
        guard let originalUrl = shortenTextField.text, !originalUrl.isEmpty else {
               showErrorAlert(message: "Lütfen Bir URL Gir.")
               return
           }
           
           logoImage.isHidden = true
           label.isHidden = true
           textField.isHidden = true
           imageView.isHidden = true
           
           titleLabel.isHidden = false
           tableView.isHidden = false
           fetchLinks()
           
           viewModel.shortenLink(originalUrl: originalUrl, title: "Shortened URL")
           
           viewModel.onLinksUpdated = { [weak self] shortenedUrl in
               guard let self = self else { return }
               
               let link = Link(destination: shortenedUrl, shortUrl: shortenedUrl)
               self.addLink(link)
           }
       }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
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
