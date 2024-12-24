//
//  HistoryVC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class HistoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var links: [Link] = []
    private let viewModel = LinkListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.reloadData()
    }
    
    func addLink(_ link: Link) {
            links.append(link)
            if isViewLoaded {
                tableView.reloadData()
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
            self?.links.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
