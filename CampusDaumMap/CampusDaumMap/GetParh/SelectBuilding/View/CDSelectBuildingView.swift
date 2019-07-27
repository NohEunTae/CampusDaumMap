//
//  CDSelectBuildingView.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDSelectBuildingView: UIView {
    @IBOutlet weak var buildingCollection: UICollectionView!
    var buildingCollectionAdapter = CDBuildingsCollectionViewAdapter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layoutBuilding: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutBuilding.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutBuilding.itemSize = CGSize(width: 105, height: 85)
        layoutBuilding.scrollDirection = .vertical
        layoutBuilding.minimumInteritemSpacing = 10
        layoutBuilding.minimumLineSpacing = 20
        buildingCollection!.collectionViewLayout = layoutBuilding
        self.buildingCollection.dataSource = buildingCollectionAdapter
        self.buildingCollection.delegate = buildingCollectionAdapter

    }

}
