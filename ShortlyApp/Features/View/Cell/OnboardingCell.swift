//
//  OnboardingCell.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class OnboardingCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
