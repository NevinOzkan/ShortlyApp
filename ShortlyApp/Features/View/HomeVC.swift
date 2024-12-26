//
//  HomeVC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var shortenTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: LinkListViewModel!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LinkListViewModel(apiService: MockAPIService())
        
        viewModel.onLinksUpdated = { [weak self] shortenedUrl in
            self?.activityIndicator.stopAnimating()
            self?.navigateToHistoryVC(with: shortenedUrl)
        }
        
      
    }
    
    @IBAction func shortenButton(_ sender: Any) {
        guard let originalUrl = shortenTextField.text, !originalUrl.isEmpty else {
            showErrorAlert(message: "Lütfen Bir URL Gir.")
            return
        }
        activityIndicator.startAnimating()
        
        viewModel.shortenLink(originalUrl: originalUrl, title: "Shortened URL")
    }

    func navigateToHistoryVC(with shortenedUrl: String) {
        let historyVC = HistoryVC(nibName: "HistoryVC", bundle: nil)
        
        historyVC.shortenedUrl = shortenedUrl
        
        let historyNavController = UINavigationController(rootViewController: historyVC)
        historyNavController.modalPresentationStyle = .fullScreen
        
        present(historyNavController, animated: true, completion: nil)
    }
       
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
