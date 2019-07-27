//
//  CDGetPathView.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

protocol CDGetPathViewDelegate {
    func gpsBtnClicked()
    func startBtnClicked()
    func arrivedBtnClicked()
    func buildingStartBtnClicked()
    func buildingArrivedBtnClicked()
    func walkClicked()
    func wheelChairClicked()
}

class CDGetPathView: UIView {
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var startPoint: UIImageView!
    @IBOutlet weak var arrivedPoint: UIImageView!
    @IBOutlet weak var startLabel: UIButton!
    @IBOutlet weak var arrivedLabel: UIButton!
    @IBOutlet weak var switchImage: UIImageView!
    @IBOutlet weak var closeImage: UIImageView!
    
    @IBOutlet weak var walking: UIButton!
    @IBOutlet weak var wheelChair: UIButton!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var arrivedBtn: UIButton!
    
    
    @IBOutlet weak var gpsBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var gpsBtn: UIButton!
    @IBOutlet weak var startSearchContainer: UIView!
    @IBOutlet weak var arrivedSearchContainer: UIView!
    
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingName: UILabel!
    @IBOutlet weak var buildingCollection: UICollectionView!
    
    @IBOutlet weak var buildingInfoView: UIView!
    
    var buildingCollectionAdpater = CDBuildingCollectionAdpater()
    var gpsBtnConstraint: NSLayoutConstraint!
    var delegate: CDGetPathViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(popViewController))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(tap)

        
        self.startLabel.addTarget(self, action: #selector(startBtnClicked), for: .touchDown)
        self.startBtn.addTarget(self, action: #selector(buildingStartBtnClicked), for: .touchDown)

        self.arrivedLabel.addTarget(self, action: #selector(arrivedBtnClicked), for: .touchDown)
        self.arrivedBtn.addTarget(self, action: #selector(buildingArrivedBtnClicked), for: .touchDown)
        
        self.gpsBtn.addTarget(self, action: #selector(gpsBtnClicked), for: .touchDown)
        
        self.walking.addTarget(self, action: #selector(walkClicked), for: .touchDown)
        self.wheelChair.addTarget(self, action: #selector(wheelChairClicked), for: .touchDown)

        self.walking.setImage(#imageLiteral(resourceName: "walk"), for: .normal)
        self.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair"), for: .normal)
        
        self.walking.setImage(#imageLiteral(resourceName: "walk_hilight"), for: .highlighted)
        self.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair_hilight"), for: .highlighted)
        
        self.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_default"), for: .normal)
        self.switchImage.image = UIImage(named: "switch")
        self.closeImage.image = #imageLiteral(resourceName: "close")
        self.startPoint.image = #imageLiteral(resourceName: "greenDot")
        self.arrivedPoint.image = #imageLiteral(resourceName: "redDot")
        self.startSearchContainer.layer.cornerRadius = 20.0
        self.startSearchContainer.clipsToBounds = true
        self.startSearchContainer.layer.borderWidth = 0.5
        self.startSearchContainer.layer.borderColor = UIColor.gray.cgColor
        
        self.arrivedSearchContainer.layer.cornerRadius = 20.0
        self.arrivedSearchContainer.clipsToBounds = true
        self.arrivedSearchContainer.layer.borderWidth = 0.5
        self.arrivedSearchContainer.layer.borderColor = UIColor.gray.cgColor
        
        self.startBtn.layer.cornerRadius = 20
        self.startBtn.clipsToBounds = true
        self.startBtn.layer.borderWidth = 0.5
        self.startBtn.layer.borderColor = UIColor.gray.cgColor
        
        self.arrivedBtn.layer.cornerRadius = 20
        
        gpsBtnConstraint = gpsBtn.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        gpsBtnConstraint.isActive = true

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        buildingCollection!.collectionViewLayout = layout
        self.buildingCollection.delegate = buildingCollectionAdpater
        self.buildingCollection.dataSource = buildingCollectionAdpater

        self.buildingInfoView.isHidden = true
    }
    
    func modifyBuildingInfo(buildingImage: UIImage, buildingName: String) {
        self.buildingName.text = buildingName
        self.buildingImage.image = buildingImage
    }
    
    func reverseHidden() {
        if self.buildingInfoView.isHidden == false {
            self.buildingInfoView.isHidden = true
            gpsBtnConstraint.constant = -30
        } else {
            self.gpsBtn.isHidden = !self.gpsBtn.isHidden
        }
    }
    
    func allHidden() {
        self.gpsBtn.isHidden = true
        self.buildingInfoView.isHidden = true
        gpsBtnConstraint.constant = -30
    }
    
    @objc func startBtnClicked() {
        self.delegate?.startBtnClicked()
    }
    
    @objc func arrivedBtnClicked() {
        self.delegate?.arrivedBtnClicked()
    }
    
    @objc func buildingStartBtnClicked() {
        allHidden()
        self.delegate?.buildingStartBtnClicked()
    }
    
    @objc func buildingArrivedBtnClicked() {
        allHidden()
        self.delegate?.buildingArrivedBtnClicked()
    }
    
    @objc func popViewController() {
        CDParentNavigationController.sharedInstance.popViewController(animated: true)
    }
    
    @objc func gpsBtnClicked() {
        self.delegate?.gpsBtnClicked()
    }
    
    @objc func walkClicked() {
        self.delegate?.walkClicked()
    }
    
    @objc func wheelChairClicked() {
        self.delegate?.wheelChairClicked()
    }
}
