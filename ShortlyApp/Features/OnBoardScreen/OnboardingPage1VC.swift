//
//  OnboardingPage1VC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class OnboardingPage1VC: UIViewController {

    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ımage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func startButton(_ sender: Any) {
        let onboardingVC = OnboardingVC()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
    
}
