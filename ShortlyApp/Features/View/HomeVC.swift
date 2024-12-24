//
//  HomeVC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var shortenTextField: UITextField!
    
    private let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func shortenButton(_ sender: Any) {
        guard let originalUrl = shortenTextField.text, !originalUrl.isEmpty else {
            showErrorAlert(message: "Please enter a valid URL.")
            return
        }
        
        apiService.shortenLink(originalUrl: originalUrl, title: "Shortened URL") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let links):
                print("Links from API:", links) 
                if let firstLink = links.first {
                    DispatchQueue.main.async {
                        self.navigateToHistoryVC(with: firstLink)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: "No link was created.")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func navigateToHistoryVC(with link: Link) {
        let historyVC = HistoryVC(nibName: "HistoryVC", bundle: nil)
        historyVC.addLink(link)
        
       
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
