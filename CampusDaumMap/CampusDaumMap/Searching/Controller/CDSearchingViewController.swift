//
//  CDSearchingViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDSearchingViewControllerDelegate {
    func facilityCellClicked(fName: String)
    func buildingCellClicked(bName: String)
}

class CDSearchingViewController: UIViewController {
    var searchingView: CDSearchingView?
    var searchBarWrapper = SearchBarContainerView()
    let searchBar = UISearchBar()

    var delegate: CDSearchingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        guard let customView = Bundle.main.loadNibNamed("CDSearchingView", owner: self, options: nil)?.first as? CDSearchingView else {
            return
        }
        searchingView = customView
        self.view.addSubview(searchingView!)
        searchingView?.delegate = self
        
        self.title = ""
        searchBar.sizeToFit()
        searchBar.placeholder = "건물, 편의시설 검색"
        searchBar.delegate = self
        
        searchBarWrapper = SearchBarContainerView(customSearchBar: searchBar)
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        
        self.navigationItem.titleView = searchBarWrapper

        let facilityCell = UINib(nibName: "CDFacilityCollectionViewCell", bundle: nil)
        searchingView?.facilityCollectionView.register(facilityCell, forCellWithReuseIdentifier: "facility")
        searchingView?.facilityAdapter.delegate = self
        searchingView?.buildingAdapter.delegate = self
        let buildingCell = UINib(nibName: "CDBuildingsCollectionViewCell", bundle: nil)
        searchingView?.buildingCollectionView.register(buildingCell, forCellWithReuseIdentifier: "building")

        let searchingCell = UINib(nibName: "CDSearchTableViewCell", bundle: nil)
        searchingView?.recentSearchListTableView.register(searchingCell, forCellReuseIdentifier: "searching")
        searchingView?.searchingAdapter.delegate = self
    }
}

extension CDSearchingViewController: CDFacilityCollectionViewAdapterDelegate {
    func facilityCellClicked(fName: String) {
        self.searchBar.endEditing(true)
        self.delegate?.facilityCellClicked(fName: fName)
        CDParentNavigationController.sharedInstance.popViewController(animated: true)
    }
}

extension CDSearchingViewController: CDBuildingsCollectionViewAdapterDelegate {
    func buildingCellClicked(bName: String) {
        self.searchBar.endEditing(true)
        self.delegate?.buildingCellClicked(bName: bName)
        CDParentNavigationController.sharedInstance.popViewController(animated: true)
    }
}

extension CDSearchingViewController: CDSearchTableViewAdapterDelegate {
    func removeBtnClicked(cell: CDSearchTableViewCell) {
        var storedData = [String]()
        
        if let RecentSearch = UserDefaults.standard.object(forKey: "RecentSearch") as? [String] {
            storedData = RecentSearch
        }
        
        for i in 0..<storedData.count {
            if storedData[i] == cell.content.text! {
                storedData.remove(at: i)
                break
            }
        }
        UserDefaults.standard.set(storedData, forKey: "RecentSearch")
        UserDefaults.standard.synchronize()

        searchingView?.setRecentDataAndReload()
    }
}
extension CDSearchingViewController: CDSearchingViewDelegate {
    func searchCellClicked(filteredData: CDSearchingModel) {
        self.searchBar.endEditing(true)
        let building = CDCoreDataManager.store.selectBuilding(bName: filteredData.name)
        
        if building != nil {
            self.delegate?.buildingCellClicked(bName: filteredData.name)
        } else {
            self.delegate?.facilityCellClicked(fName: filteredData.name)
        }
        CDParentNavigationController.sharedInstance.popViewController(animated: true)
    }
    
    func removeAllSearchDataBtnClicked() {
        self.alert(title: "최근 검색어 삭제", message: "최근 검색어를 모두 삭제하시겠습니까?",yes: "확인", no: "취소", yesAction: {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: "RecentSearch")
                UserDefaults.standard.synchronize()
                self.searchingView?.setRecentDataAndReload()
            }
        }) {
        }
    }
    
    func alert(title: String, message: String, yes: String = "네", no: String = "아니요", yesAction: (@escaping()->()), noAction: (()->())?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesBT = UIAlertAction(title: yes, style: .default) {
            (action: UIAlertAction) -> Void in
            yesAction()
        }
        
        
        let noBT = UIAlertAction(title: no, style: .default) {
            (action: UIAlertAction) -> Void in
            noAction?()
        }
        
        alert.addAction(noBT)
        alert.addAction(yesBT)
        
        self.present(alert, animated: false, completion: nil)
    }
}

class SearchBarContainerView: UIView {
    let searchBar: UISearchBar
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
    }
    
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
