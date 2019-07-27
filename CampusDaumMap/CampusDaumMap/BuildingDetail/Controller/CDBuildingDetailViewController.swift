//
//  CDBuildingDetailViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDBuildingDetailViewController: UIViewController {
    
    var building: Building?
    var detailView: CDBuildingDetailView?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = building?.bName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let customView = Bundle.main.loadNibNamed("CDBuildingDetailView", owner: self, options: nil)?.first as? CDBuildingDetailView else {
            return
        }
        detailView = customView
        
        self.detailView?.layerTableViewAdapter.layers = building?.layer?.array as? [Layers]
        self.detailView?.layerTableViewAdapter.layers?.sort(by: { (now, next) -> Bool in
            now.stairNumb > next.stairNumb
        })
        
        for layer in self.detailView!.layerTableViewAdapter.layers! {
            print(layer.stairNumb)
        }
        

        let searchingCell = UINib(nibName: "CDBuildingDetailTableViewCell", bundle: nil)
        detailView?.layerTableView.register(searchingCell, forCellReuseIdentifier: "buildingDetail")
        detailView?.layerTableViewAdapter.delegate = self
        
        self.view.addSubview(self.detailView!)

        
        // Do any additional setup after loading the view.
    }
}

extension CDBuildingDetailViewController: CDBuildingDetailTableViewAdapterDelegate {
    func tableCellDidClicked(layer: Layers) {
        let layerDetailVC = CDLayerDetailViewController(nibName: "CDLayerDetailViewController", bundle: nil)
        layerDetailVC.layer = layer
        CDParentNavigationController.sharedInstance.pushViewController(layerDetailVC, animated: true)
    }
}
