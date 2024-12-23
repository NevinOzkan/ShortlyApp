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
    @IBOutlet weak var delegateIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func copyButton(_ sender: Any) {
    }
    
}
