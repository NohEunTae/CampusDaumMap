//
//  CDSearchingView.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDSearchingViewDelegate {
    func removeAllSearchDataBtnClicked()
}

class CDSearchingView: UIView {
    @IBOutlet weak var secondSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var secondSectionTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var firstSectionTopMargin: NSLayoutConstraint!
    @IBOutlet weak var facilityHeight: NSLayoutConstraint!
    @IBOutlet weak var firstSectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buildingHeight: NSLayoutConstraint!
    
    @IBOutlet weak var facilityCollectionView: UICollectionView!
    
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var buildingCollectionView: UICollectionView!
    
    @IBOutlet weak var recentSearchListTableView: UITableView!
    @IBOutlet weak var recentSearching: UILabel!
    @IBOutlet weak var deleteAll: UILabel!
    
    var facilityAdapter = CDFacilityCollectionViewAdapter()
    var buildingAdapter = CDBuildingsCollectionViewAdapter()
    var searchingAdapter = CDSearchTableViewAdapter()
    var delegate: CDSearchingViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeAllBtnClicked))
        deleteAll.isUserInteractionEnabled = true
        deleteAll.addGestureRecognizer(tap)
        
        let layoutFacility: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutFacility.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutFacility.itemSize = CGSize(width: 40, height: 40)
        layoutFacility.scrollDirection = .horizontal
        layoutFacility.minimumInteritemSpacing = 10
        layoutFacility.minimumLineSpacing = 20
        facilityCollectionView!.collectionViewLayout = layoutFacility
        facilityCollectionView.delegate = self.facilityAdapter
        facilityCollectionView.dataSource = self.facilityAdapter
        
        let layoutBuilding: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutBuilding.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutBuilding.itemSize = CGSize(width: 105, height: 85)
        layoutBuilding.scrollDirection = .horizontal
        layoutBuilding.minimumInteritemSpacing = 10
        layoutBuilding.minimumLineSpacing = 20
        buildingCollectionView!.collectionViewLayout = layoutBuilding
        buildingCollectionView.delegate = self.buildingAdapter
        buildingCollectionView.dataSource = self.buildingAdapter
        
        recentSearchListTableView.delegate = self.searchingAdapter
        recentSearchListTableView.dataSource = self.searchingAdapter
        
        setRecentDataAndReload()
    }
    
    @objc func removeAllBtnClicked() {
        self.delegate?.removeAllSearchDataBtnClicked()
    }
    
    func setDataAndReload(filteredData: [CDSearchingModel]) {
        self.searchingAdapter.filteredData = filteredData
        self.recentSearchListTableView.reloadData()
    }
    
    func setRecentDataAndReload() {
        var storedData = [String]()
        self.searchingAdapter.filteredData = []
        if let RecentSearch = UserDefaults.standard.object(forKey: "RecentSearch") as? [String] {
            storedData = RecentSearch
        }
        
        self.deleteAll.isHidden = storedData.isEmpty ? true : false
        
        var removeIndexs: [Int] = []
        for i in 0 ..< storedData.count {
            var isExist: Bool = false
            
            for j in 0 ..< facilityAdapter.facilities.count {
                if facilityAdapter.facilities[j].fName == storedData[i] {
                    isExist = true
                    let searching = CDSearchingModel(name: facilityAdapter.facilities[j].fName!, imageName: facilityAdapter.facilities[j].iconName!)
                    self.searchingAdapter.filteredData.append(searching)
                }
            }
            
            for j in 0 ..< buildingAdapter.buildings.count {
                if buildingAdapter.buildings[j].bName == storedData[i] {
                    isExist = true
                    let searching = CDSearchingModel(name: buildingAdapter.buildings[j].bName!, imageName: "search_icon")
                    self.searchingAdapter.filteredData.append(searching)
                }
            }
            
            if isExist == false {
                removeIndexs.append(i)
            }
        }
        
        for i in removeIndexs {
            storedData.remove(at: i)
        }
        
        if storedData.isEmpty == false {
            UserDefaults.standard.set(storedData, forKey: "RecentSearch")
            UserDefaults.standard.synchronize()
        }
        recentSearchListTableView.reloadData()
    }
}
