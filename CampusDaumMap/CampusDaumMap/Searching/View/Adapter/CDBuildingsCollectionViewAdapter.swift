//
//  CDBuildingsCollectionViewAdapter.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDBuildingsCollectionViewAdapterDelegate {
    func buildingCellClicked(bName: String)
}

class CDBuildingsCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegate: CDBuildingsCollectionViewAdapterDelegate?
    let buildings = CDCoreDataManager.store.selectAllCoreDataObjectFromBuilding()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CDBuildingsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "building", for: indexPath) as! CDBuildingsCollectionViewCell
        cell.buildingBlurImage.image = UIImage(named: "\(String(describing: buildings[indexPath.row].bImage!))_blur")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.buildingCellClicked(bName: buildings[indexPath.row].bName!)
    }
}
