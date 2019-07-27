//
//  CDBuildingDetailView.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class CDBuildingDetailView: UIView {
    
    @IBOutlet weak var layerTableView: UITableView!
    var layerTableViewAdapter = CDBuildingDetailTableViewAdapter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layerTableView.delegate = self.layerTableViewAdapter
        layerTableView.dataSource = self.layerTableViewAdapter
    }
    
}
