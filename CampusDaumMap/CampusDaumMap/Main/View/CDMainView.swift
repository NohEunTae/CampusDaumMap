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
}

class CDMainView: UIView {
    @IBOutlet weak var zoomInBtn: UIButton!
    @IBOutlet weak var zoomOutBtn: UIButton!
        
    @IBOutlet weak var mapContainer: UIView!
    
    var delegate: CDMainViewDelegate?
    
    @IBOutlet weak var gpsBtn: UIButton!

    @IBOutlet weak var searchBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.gpsBtn.addTarget(self, action: #selector(gpsBtnClicked), for: .touchDown)
        self.searchBtn.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        self.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_default"), for: .normal)
        self.zoomInBtn.setImage(#imageLiteral(resourceName: "zoomIn"), for: .normal)
        self.zoomOutBtn.setImage(#imageLiteral(resourceName: "zoomOut"), for: .normal)
        
        self.zoomInBtn.addTarget(self, action: #selector(zoomInBtnClicked), for: .touchDown)
        self.zoomOutBtn.addTarget(self, action: #selector(zoomOutBtnClicked), for: .touchDown)
    }
    
    @objc func gpsBtnClicked() {
        self.delegate?.myLocationBtnClicked()
    }
    
    @objc func zoomInBtnClicked() {
        self.delegate?.zoomInBtnClicked()
    }
    
    @objc func zoomOutBtnClicked() {
        self.delegate?.zoomOutBtnClicked()
    }
    
    func reverseViewsHidden() {
        self.searchBtn.isHidden = !self.searchBtn.isHidden
        self.gpsBtn.isHidden = !self.gpsBtn.isHidden
        self.zoomInBtn.isHidden = !self.zoomInBtn.isHidden
        self.zoomOutBtn.isHidden = !self.zoomOutBtn.isHidden
    }
}
