//
//  CDGetPathViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import CoreLocation

class CDGetPathViewController: UIViewController, NMapViewDelegate, EAGetUserLocationProtocol{

    var getPathView: CDGetPathView?
    var startBuilding: Building?
    var arrivedBuiling: Building?

    var mapView: NMapView?
    var currentState: state = .disabled
    var overlay: NMapPOIdataOverlay?

    var userLocationManager: EAGetUserLocation  = EAGetUserLocation()
    var pathList: Path?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let customView = Bundle.main.loadNibNamed("CDGetPathView", owner: self, options: nil)?.first as? CDGetPathView else {
            return
        }

        getPathView = customView
        userLocationManager.delegate = self;
        mapView = NMapView(frame: self.view.frame)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.setZoomEnabled(true)
            mapView.setClientId("KfDJpcLBqgmp2A1x_S9L")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        self.getPathView?.delegate = self
        self.getPathView?.mainContainer.addSubview(mapView!)
        self.view.addSubview(getPathView!)

        let nibCell = UINib(nibName: "CDFacilityCollectionViewCell", bundle: nil)
        getPathView?.buildingCollection.register(nibCell, forCellWithReuseIdentifier: "facility")
    }
    
    func setFromAndTo(type: pathType) {
        if self.startBuilding != nil && self.arrivedBuiling != nil {
            let start = (self.startBuilding?.gpsInfo?.array as! [GPSInfo]).first!
            let arrive = (self.arrivedBuiling?.gpsInfo?.array as! [GPSInfo]).first!
            let from = Node(latitude: start.latitude, longitude: start.longitude)
            let to = Node(latitude: arrive.latitude, longitude: arrive.longitude)
            self.pathList = getShortestPathWithGraph(from: from, to: to, type: type)
            drawLine()
        }
    }
    
    func drawbuildingMarker() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                self.overlay = poiDataOverlay
                let buildingGpsInfos = CDCoreDataManager.store.selectAllCoreDataObjectFromBuilding()
                poiDataOverlay.initPOIdata(Int32(buildingGpsInfos.count))
                for building in buildingGpsInfos {
                    let lon = (building.gpsInfo?.array.first! as! GPSInfo).longitude
                    let lat = (building.gpsInfo?.array.first! as! GPSInfo).latitude
                    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: lon, latitude: lat), title: "마커", type: NMapPOIflagTypeBuilding, iconIndex: 0, with : nil)
                }
                poiDataOverlay.endPOIdata()
                poiDataOverlay.showAllPOIdata()
            }
        }
    }
    
    func getCurrentUserLocation(withCurrentLocation location: CLLocation!) {
        print("print \(location.coordinate.latitude) \(location.coordinate.longitude)")
//        print("print \(addr)")
    }
    
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            drawbuildingMarker()
            mapView.setMapCenter(NGeoPoint(longitude: 127.13189904501529, latitude: 37.27429113751279), atLevel: 12)

            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    
}

extension CDGetPathViewController: NMapPOIdataOverlayDelegate {
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    func onMapView(_ mapView: NMapView!, handleSingleTapGesture recogniser: UIGestureRecognizer!) {
        getPathView?.reverseHidden()
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        let lat = poiItem.location.latitude
        let lon = poiItem.location.longitude
        
        let gpsInfo = CDCoreDataManager.store.selectGPS(latitude: lat, longitude: lon)
        let layers = gpsInfo?.building?.layer?.array as! [Layers]
        let facilitiesSet = NSMutableOrderedSet()

        for layer in layers {
            for each in layer.eachLayerFacilities?.array as! [EachLayerFacilities] {
                facilitiesSet.add(each.facility!)
            }
        }

        self.getPathView?.gpsBtn.isHidden = false
        self.getPathView?.modifyBuildingInfo(buildingImage: UIImage(named: gpsInfo!.building!.bImage!)!, buildingName: gpsInfo!.building!.bName!)
        self.getPathView?.buildingCollectionAdpater.facilities = facilitiesSet.array as! [Facility]
        self.getPathView?.buildingCollection.reloadData()
        self.getPathView?.gpsBtnConstraint.constant = -10 - getPathView!.buildingInfoView.layer.frame.height
        self.getPathView?.buildingInfoView.isHidden = false
        return nil
    }
    
    func drawLine() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            if let pathData = NMapPathData.init(capacity: 20) {
                pathData.initPathData()
                if let succession: [Node] = pathList?.array.reversed().compactMap({ $0 as Node}) {
                    for data in succession {
                        pathData.addPathPointLongitude(data.longitude, latitude: data.latitude, lineType: .dash)
                    }
                } else {
                    
                }
                pathData.end()
                
                // create path data overlay
                if let pathDataOverlay = mapOverlayManager.newPathDataOverlay(pathData) {
                    pathDataOverlay.showAllPathData()
                }
            }
        }
    }
}

extension CDGetPathViewController: NMapLocationManagerDelegate {
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        let coordinate: CLLocationCoordinate2D = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = location.horizontalAccuracy
        self.mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: Float(locationAccuracy))
        self.mapView?.setMapCenter(myLocation)
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        print("failed")
    }
}

extension CDGetPathViewController: CDGetPathViewDelegate {
    func alert(title: String, message: String, bt: String, btAction: (()->())?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let BT = UIAlertAction(title: bt, style: .default) {
            (action: UIAlertAction) -> Void in
            btAction?()
        }
        alert.addAction(BT)
        self.present(alert, animated: false, completion: nil)
    }
    
    
    func walkClicked() {
        if startBuilding == nil || arrivedBuiling == nil {
            alert(title: "경로를 찾을 수 없습니다", message: "출발지/도착지를 설정하세요", bt: "확인", btAction: nil)
            return
        }
        self.getPathView?.walking.setImage(#imageLiteral(resourceName: "walk_hilight"), for: .normal)
        self.getPathView?.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair"), for: .normal)
        setFromAndTo(type: pathType.walk)
    }
    
    func wheelChairClicked() {
        if startBuilding == nil || arrivedBuiling == nil {
            alert(title: "경로를 찾을 수 없습니다", message: "출발지/도착지를 설정하세요", bt: "확인", btAction: nil)
            return
        }
        self.getPathView?.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair_hilight"), for: .normal)
        self.getPathView?.walking.setImage(#imageLiteral(resourceName: "walk"), for: .normal)
        setFromAndTo(type: pathType.wheelChair)
    }
    
    func startBtnClicked() {
        let selectBuildingVC = CDSelectBuildingViewController(nibName: "CDSelectBuildingViewController", bundle: nil)
        selectBuildingVC.isStartPoint = true
        selectBuildingVC.delegate = self
        CDParentNavigationController.sharedInstance.pushViewController(selectBuildingVC, animated: true)
    }
    
    func arrivedBtnClicked() {
        let selectBuildingVC = CDSelectBuildingViewController(nibName: "CDSelectBuildingViewController", bundle: nil)
        selectBuildingVC.isStartPoint = false
        selectBuildingVC.delegate = self
        CDParentNavigationController.sharedInstance.pushViewController(selectBuildingVC, animated: true)
    }
    
    func buildingStartBtnClicked() {
        self.getPathView?.startLabel.setTitle("출발 : \(getPathView!.buildingName.text!)", for: .normal)
        self.startBuilding = CDCoreDataManager.store.selectBuilding(bName: getPathView!.buildingName.text!)
        
        if self.startBuilding != nil && self.arrivedBuiling != nil {
            self.getPathView?.walking.setImage(#imageLiteral(resourceName: "walk_hilight"), for: .normal)
            self.getPathView?.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair"), for: .normal)
        }
        
        setFromAndTo(type: pathType.walk)
    }
    
    func buildingArrivedBtnClicked() {
        self.getPathView?.arrivedLabel.setTitle("도착 : \(getPathView!.buildingName.text!)", for: .normal)
        self.arrivedBuiling = CDCoreDataManager.store.selectBuilding(bName: getPathView!.buildingName.text!)
        
        if self.startBuilding != nil && self.arrivedBuiling != nil {
            self.getPathView?.walking.setImage(#imageLiteral(resourceName: "walk_hilight"), for: .normal)
            self.getPathView?.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair"), for: .normal)
        }
    
        setFromAndTo(type: pathType.walk)
    }
    
    func gpsBtnClicked() {
        if let lm = NMapLocationManager.getSharedInstance() {
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            self.getPathView?.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_default"), for: .normal)
        case .tracking:
            self.getPathView?.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_active"), for: .normal)
        case .trackingWithHeading:
            self.getPathView?.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_tracking"), for: .normal)
        }
    }
    
    func stopLocationUpdating() {
        disableHeading()
        disableLocationUpdate()
    }
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                lm.setDelegate(self)
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                lm.stopUpdateLocationInfo()
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
}

extension CDGetPathViewController: CDSelectBuildingViewControllerDelegate {
    func startPoint(bName: String) {
        self.getPathView?.startLabel.setTitle("출발 : \(bName)", for: .normal)
        self.startBuilding = CDCoreDataManager.store.selectBuilding(bName: bName)
        
        if self.startBuilding != nil && self.arrivedBuiling != nil {
            self.getPathView?.walking.setImage(#imageLiteral(resourceName: "walk_hilight"), for: .normal)
            self.getPathView?.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair"), for: .normal)
        }
        
        setFromAndTo(type: pathType.walk)
    }
    
    func arrivedPoint(bName: String) {
        self.getPathView?.arrivedLabel.setTitle("도착 : \(bName)", for: .normal)
        self.arrivedBuiling = CDCoreDataManager.store.selectBuilding(bName: bName)
        
        if self.startBuilding != nil && self.arrivedBuiling != nil {
            self.getPathView?.walking.setImage(#imageLiteral(resourceName: "walk_hilight"), for: .normal)
            self.getPathView?.wheelChair.setImage(#imageLiteral(resourceName: "wheelChair"), for: .normal)
        }
        
        setFromAndTo(type: pathType.walk)
    }
}
