//
//  ShortLinkCell.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class ShortLinkCell: UITableViewCell {
    
    
    @IBOutlet weak var longUrl: UILabel!
    @IBOutlet weak var shortUrl: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var delegateIcon: UIButton!
    
    
    var onDelete: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(with link: Link) {
        longUrl.text = link.destination
        shortUrl.text = link.shortUrl
    }

    @IBAction func deleteCell(_ sender: Any) {
        onDelete?()
    }
    
    @IBAction func copyButton(_ sender: Any) {
        UIPasteboard.general.string = shortUrl.text
        
        if let button = sender as? UIButton {
            button.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            button.setTitle("COPIED", for: .normal)
            button.titleLabel?.textColor = .blue

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                button.setTitle("COPY", for: .normal)
                button.backgroundColor = .clear
            }
        }
    }
}
