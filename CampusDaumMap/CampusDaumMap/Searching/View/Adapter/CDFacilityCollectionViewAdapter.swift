//
//  CDSearchingView+CollectionView.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

protocol CDFacilityCollectionViewAdapterDelegate {
    func facilityCellClicked(fName: String)
}

class CDFacilityCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    let facilities = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter {
        $0.iconName != "f_icon_womanToilet" && $0.iconName != "f_icon_manToilet" &&
            $0.iconName != "f_icon_publicToiletWoman" && $0.iconName != "f_icon_park"
    }
    var delegate: CDFacilityCollectionViewAdapterDelegate?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CDFacilityCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "facility", for: indexPath) as! CDFacilityCollectionViewCell
        cell.modifyCell(image: UIImage(named: facilities[indexPath.row].iconName!)!, fName: facilities[indexPath.row].fName!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CDFacilityCollectionViewCell else {
            return
        }
        self.delegate?.facilityCellClicked(fName: cell.fName)
    }
}
