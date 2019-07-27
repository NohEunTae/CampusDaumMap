//
//  CDBuildingDetailTableViewAdapter.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDBuildingDetailTableViewAdapterDelegate {
    func tableCellDidClicked(layer: Layers)
}

class CDBuildingDetailTableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    var layers: [Layers]?
    var delegate: CDBuildingDetailTableViewAdapterDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildingDetail", for: indexPath) as! CDBuildingDetailTableViewCell
        
        let facilities = (layers![indexPath.row].eachLayerFacilities?.array as! [EachLayerFacilities]).map { $0.facility }
        cell.modifyCell(layer: Int(layers![indexPath.row].stairNumb),
                        facilities: facilities as! [Facility])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.tableCellDidClicked(layer: layers![indexPath.row])
    }
}
