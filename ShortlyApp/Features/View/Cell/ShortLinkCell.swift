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
    
    var shortenedUrl: String?
    var onDelete: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 30, left: 25, bottom: 10, right: 25))
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
        }
    }
}
