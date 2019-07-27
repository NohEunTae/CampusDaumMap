
//
//  CDFacilityCollectionViewCell.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDFacilityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var facilityIcon: UIImageView!
    var fName: String = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func modifyCell(image: UIImage, fName: String) {
        facilityIcon.image = image
        self.fName = fName
    }

}
