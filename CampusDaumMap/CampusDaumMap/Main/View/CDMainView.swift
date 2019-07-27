//
//  TestView.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 25..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDMainViewDelegate {
    func myLocationBtnClicked()
    func zoomInBtnClicked()
    func zoomOutBtnClicked()
    func searchingBtnClicked()
    func swipeOrtapBuildingInfo()
    func getPathBtnClicked()
    func arrivedBtnClicked()
    func startBtnClicked()
}

class CDMainView: UIView {
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var arrivedBtn: UIButton!
    @IBOutlet weak var buildingCollection: UICollectionView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingName: UILabel!
    
    @IBOutlet weak var zoomInBtn: UIButton!
    @IBOutlet weak var zoomOutBtn: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var searchingBtn: UIButton!
    
    @IBOutlet weak var buildingInfoView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var mapContainer: UIView!
    
    var delegate: CDMainViewDelegate?
    var buildingCollectionAdpater = CDBuildingCollectionAdpater()
    
    @IBOutlet weak var gpsBtn: UIButton!

    @IBOutlet weak var searchBtn: UIButton!
    
    
    var gpsBtnConstraint: NSLayoutConstraint!
    var searchBtnConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.gpsBtn.addTarget(self, action: #selector(gpsBtnClicked), for: .touchDown)
        self.searchingBtn.addTarget(self, action: #selector(searchingBtnClicked), for: .touchDown)
        self.searchBtn.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        self.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_default"), for: .normal)
        self.zoomInBtn.setImage(#imageLiteral(resourceName: "zoomIn"), for: .normal)
        self.zoomOutBtn.setImage(#imageLiteral(resourceName: "zoomOut"), for: .normal)

        self.searchImage.image = #imageLiteral(resourceName: "search_icon")
        self.settingImage.image = #imageLiteral(resourceName: "setting")
        
        self.searchContainerView.layer.cornerRadius = 20.0
        self.searchContainerView.clipsToBounds = true
        self.searchContainerView.layer.borderWidth = 0.5
        self.searchContainerView.layer.borderColor = UIColor.gray.cgColor
        
        self.zoomInBtn.addTarget(self, action: #selector(zoomInBtnClicked), for: .touchDown)
        self.zoomOutBtn.addTarget(self, action: #selector(zoomOutBtnClicked), for: .touchDown)
        self.searchBtn.addTarget(self, action: #selector(getPathBtnClicked), for: .touchDown)
        self.arrivedBtn.addTarget(self, action: #selector(arrivedBtnClicked), for: .touchDown)
        self.startBtn.addTarget(self, action: #selector(startBtnClicked), for: .touchDown)
        
        self.startBtn.layer.cornerRadius = 20
        self.startBtn.clipsToBounds = true
        self.startBtn.layer.borderWidth = 0.5
        self.startBtn.layer.borderColor = UIColor.gray.cgColor

        self.arrivedBtn.layer.cornerRadius = 20
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        buildingCollection!.collectionViewLayout = layout
        buildingCollection.delegate = self.buildingCollectionAdpater
        buildingCollection.dataSource = self.buildingCollectionAdpater
        
        gpsBtnConstraint = gpsBtn.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        gpsBtnConstraint.isActive = true

        searchBtnConstraint = searchBtn.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        searchBtnConstraint.isActive = true

        self.buildingInfoView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchOrSwipeUp))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(touchOrSwipeUp))
        swipeUp.direction = .up
        self.buildingInfoView.isUserInteractionEnabled = true
        self.buildingInfoView.addGestureRecognizer(tap)
        self.buildingInfoView.addGestureRecognizer(swipeUp)
    }
    
    @objc func touchOrSwipeUp() {
        self.delegate?.swipeOrtapBuildingInfo()
    }
    
    func modifyBuildingInfo(buildingImage: UIImage, buildingName: String) {
        self.buildingName.text = buildingName
        self.buildingImage.image = buildingImage
    }
    
    @objc func gpsBtnClicked() {
        self.delegate?.myLocationBtnClicked()
    }
    
    @objc func getPathBtnClicked() {
        self.delegate?.getPathBtnClicked()
    }
    
    @objc func zoomInBtnClicked() {
        self.delegate?.zoomInBtnClicked()
    }
    
    @objc func zoomOutBtnClicked() {
        self.delegate?.zoomOutBtnClicked()
    }

    @objc func searchingBtnClicked() {
        self.delegate?.searchingBtnClicked()
    }

    @objc func startBtnClicked() {
        self.delegate?.startBtnClicked()
    }
    
    @objc func arrivedBtnClicked() {
        self.delegate?.arrivedBtnClicked()
    }


    
    func reverseViewsHidden() {
        if self.buildingInfoView.isHidden == false {
            self.buildingInfoView.isHidden = true
            gpsBtnConstraint.constant = -30
            searchBtnConstraint.constant = -30
        } else {
            self.searchBtn.isHidden = !self.searchBtn.isHidden
            self.gpsBtn.isHidden = !self.gpsBtn.isHidden
            self.zoomInBtn.isHidden = !self.zoomInBtn.isHidden
            self.zoomOutBtn.isHidden = !self.zoomOutBtn.isHidden
            self.searchContainerView.isHidden = !self.searchContainerView.isHidden
        }
    }
    
    func viewsHiddenOff() {
        self.searchBtn.isHidden = false
        self.gpsBtn.isHidden = false
        self.zoomInBtn.isHidden = false
        self.zoomOutBtn.isHidden = false
        self.searchContainerView.isHidden = false
    }
}
