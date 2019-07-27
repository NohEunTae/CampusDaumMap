//
//  CDSearchTableViewCell.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDSearchTableViewCellDelegate {
    func removeBtnClicked(cell: CDSearchTableViewCell)
}

class CDSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var delegate: CDSearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteBtn.addTarget(self, action: #selector(removeBtnClicked), for: .touchDown)
        // Initialization code
    }

    @objc func removeBtnClicked() {
        self.delegate?.removeBtnClicked(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func modifyCellRecent(icon: UIImage, content: String) {
        DispatchQueue.main.async {
            self.deleteBtn.isHidden = false
            self.deleteBtn.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
            self.icon.image = icon
            self.content.text = content
        }
    }
    
    func modifyCellSearching(icon: UIImage, content: String) {
        DispatchQueue.main.async {
            self.deleteBtn.isHidden = true
            self.icon.image = icon
            self.content.text = content
        }
    }
    
}
