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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shortenTextField: UITextField!
    
    private var viewModel: LinkListViewModel!
    
    private var container: ModelContainer? {
        return (UIApplication.shared.delegate as? AppDelegate)?.container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel = LinkListViewModel(apiService: MockAPIService(), container: container)
        
        viewModel.onLinksUpdated = { [weak self] links in
            self?.viewModel.links = links
            
            if links.isEmpty {
                self?.imageView.isHidden = false
                self?.descriptionLabel.isHidden = false
                self?.label.isHidden = false
                self?.tableView.isHidden = true
                self?.titleLabel.isHidden = true
                self?.logoImage.isHidden = false
            } else {
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
                self?.imageView.isHidden = true
                self?.descriptionLabel.isHidden = true
                self?.label.isHidden = true
                self?.titleLabel.isHidden = false
                self?.logoImage.isHidden = true
            }
        }
        
        viewModel.fetchLinks()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: "ShortLinkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShortLinkCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addLink(_ link: Link) {
        let newIndexPath = IndexPath(row: viewModel.links.count, section: 0)
        viewModel.links.append(link)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    @IBAction func shortenButton(_ sender: Any) {
        guard let originalUrl = shortenTextField.text, !originalUrl.isEmpty else {
            showErrorAlert(message: "Lütfen Bir URL Gir.")
            return
        }
        
        viewModel.shortenLink(originalUrl: originalUrl, title: "Shortened URL")
        
        shortenTextField.text = ""
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShortLinkCell", for: indexPath) as? ShortLinkCell else {
            return UITableViewCell()
        }
        
        let link = viewModel.links[indexPath.row]
        cell.configureCell(with: link)
        
        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteLink(at: indexPath)
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
   
}
