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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let container = container {
            viewModel = LinkListViewModel(apiService: MockAPIService(), container: container)
            
            viewModel.onLinksUpdated = { [weak self] links in
                self?.links = links
                self?.tableView.reloadData()
            }
            
            viewModel.fetchLinks()
        } else {
            print("Container bulunamadı.")
        }
        
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
        let newIndexPath = IndexPath(row: links.count, section: 0)
        links.append(link)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
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
        
        viewModel.shortenLink(originalUrl: originalUrl, title: "Shortened URL")
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
            self.viewModel.deleteLink(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
