//
//  CDSearching+SearchDelegate.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation

extension CDSearchingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchingView?.searchingAdapter.isSearchMode = true
        let buildings = self.searchingView?.buildingAdapter.buildings.filter {
            ($0.bName?.localizedCaseInsensitiveContains(searchText))!
        }
        let facilities = self.searchingView?.facilityAdapter.facilities.filter {
            ($0.fName?.localizedCaseInsensitiveContains(searchText))!
        }
        
        var filteredData: [CDSearchingModel] = []
        
        for building in buildings! {
            let searching = CDSearchingModel(name: building.bName!, imageName: "search_icon")
            filteredData.append(searching)
        }
        
        for facility in facilities! {
            let searching = CDSearchingModel(name: facility.fName!, imageName: facility.iconName!)
            filteredData.append(searching)
        }
        
        self.searchingView?.setDataAndReload(filteredData: filteredData)

        if searchText == "" {
            self.searchingView?.setRecentDataAndReload()
            self.searchingView?.recentSearching.text = "최근검색"
            showCollectionViews()
        } else {
            self.searchingView?.recentSearching.text = "검색중.."
            self.searchingView?.deleteAll.isHidden = true
            hideCollectionViews()
        }
    }
    
    func searchFeild(searchField: UISearchBar, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchingView?.recentSearching.text = "최근검색"
        showCollectionViews()
        self.searchingView?.setRecentDataAndReload()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.searchingView?.setRecentDataAndReload()
        }
    }
    
    func hideCollectionViews() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchingView?.facilityHeight.constant = 0
            self.searchingView?.buildingHeight.constant = 0
            self.searchingView?.firstSectionHeight.constant = 0
            self.searchingView?.secondSectionHeight.constant = 0
            self.searchingView?.secondSectionTopMargin.constant = 0
            self.searchingView?.firstSectionTopMargin.constant = 0
        })
    }
    
    func showCollectionViews() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchingView?.facilityHeight.constant = 50
            self.searchingView?.buildingHeight.constant = 100
            self.searchingView?.firstSectionHeight.constant = 40
            self.searchingView?.secondSectionHeight.constant = 40
            self.searchingView?.secondSectionTopMargin.constant = 16
            self.searchingView?.firstSectionTopMargin.constant = 16
        })
    }
}
