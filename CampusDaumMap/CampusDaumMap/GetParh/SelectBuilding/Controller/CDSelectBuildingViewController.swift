//
//  CDSelectBuildingViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDSelectBuildingViewControllerDelegate {
    func startPoint(bName: String)
    func arrivedPoint(bName: String)
}

class CDSelectBuildingViewController: UIViewController {

    var selectBuildingView: CDSelectBuildingView?
    var isStartPoint = false
    var delegate: CDSelectBuildingViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if isStartPoint {
            self.title = "출발지 선택"
        } else {
            self.title = "도착지 선택"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let customView = Bundle.main.loadNibNamed("CDSelectBuildingView", owner: self, options: nil)?.first as? CDSelectBuildingView else {
            return
        }
        
        selectBuildingView = customView
        selectBuildingView?.buildingCollectionAdapter.delegate = self
        
        let buildingCell = UINib(nibName: "CDBuildingsCollectionViewCell", bundle: nil)
        selectBuildingView?.buildingCollection.register(buildingCell, forCellWithReuseIdentifier: "building")

        self.view.addSubview(selectBuildingView!)
        
        
        // Do any additional setup after loading the view.
    }
}

extension CDSelectBuildingViewController: CDBuildingsCollectionViewAdapterDelegate {
    func buildingCellClicked(bName: String) {
        if isStartPoint {
            self.delegate?.startPoint(bName: bName)
        } else {
            self.delegate?.arrivedPoint(bName: bName)
        }
        CDParentNavigationController.sharedInstance.popViewController(animated: true)
    }
    
    
}
