//
//  CDBuildingDetailTableViewCell.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDBuildingDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var layerLabel: UILabel!
    @IBOutlet weak var facilityCollectionView: UICollectionView!
    var facilities: [Facility]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layoutFacility: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutFacility.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutFacility.itemSize = CGSize(width: 30, height: 30)
        layoutFacility.scrollDirection = .horizontal
        layoutFacility.minimumInteritemSpacing = 10
        layoutFacility.minimumLineSpacing = 20
        facilityCollectionView!.collectionViewLayout = layoutFacility
        
        let facilityCell = UINib(nibName: "CDFacilityCollectionViewCell", bundle: nil)
        facilityCollectionView.register(facilityCell, forCellWithReuseIdentifier: "facility")

        self.facilityCollectionView.delegate = self
        self.facilityCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func modifyCell(layer: Int, facilities: [Facility]) {
        if layer == -1 {
            layerLabel.text = "B1F"
        } else {
            layerLabel.text = "\(layer)F"
        }
        self.facilities = facilities
        facilityCollectionView.reloadData()
    }
}

extension CDBuildingDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.facilities!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CDFacilityCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "facility", for: indexPath) as! CDFacilityCollectionViewCell
        cell.modifyCell(image: UIImage(named: facilities![indexPath.row].iconName!)!, fName: facilities![indexPath.row].fName!)
        return cell
    }
    
    
}

