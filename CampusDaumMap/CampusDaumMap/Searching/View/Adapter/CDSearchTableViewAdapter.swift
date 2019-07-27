//
//  CDSearchTableViewAdapter.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDSearchTableViewAdapterDelegate {
    func removeBtnClicked(cell: CDSearchTableViewCell)
    func searchCellClicked(filteredData: CDSearchingModel)
}

class CDSearchTableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var isSearchMode = false
    var filteredData = [CDSearchingModel]()
    var delegate: CDSearchTableViewAdapterDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searching", for: indexPath) as! CDSearchTableViewCell
        if isSearchMode {
            cell.modifyCellSearching(icon: UIImage(named: filteredData[indexPath.row].imageName)!, content: filteredData[indexPath.row].name)
        } else {
            cell.modifyCellRecent(icon: UIImage(named: filteredData[indexPath.row].imageName)!, content: filteredData[indexPath.row].name)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CDSearchTableViewCell
        
        var storedData = [String]()
        
        if let RecentSearch = UserDefaults.standard.object(forKey: "RecentSearch") as? [String] {
            storedData = RecentSearch
        }
        
        if storedData.count > 20 {
            storedData.removeLast()
        }
        storedData.insert(cell.content.text!, at: 0)
        UserDefaults.standard.set(storedData, forKey: "RecentSearch")
        UserDefaults.standard.synchronize()

        self.delegate?.searchCellClicked(filteredData: filteredData[indexPath.row])
    }
}

extension CDSearchTableViewAdapter: CDSearchTableViewCellDelegate {
    func removeBtnClicked(cell: CDSearchTableViewCell) {
        self.delegate?.removeBtnClicked(cell: cell)
    }
}
