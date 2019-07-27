//
//  ViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 25..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

enum state {
    case disabled
    case tracking
    case trackingWithHeading
}

class CDMainViewController: UIViewController, NMapViewDelegate {
    var mapView: NMapView?
    var mainView: CDMainView?
    var currentState: state = .disabled
    var overlay: NMapPOIdataOverlay?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.mainView?.buildingInfoView.isHidden = true
        self.mainView?.gpsBtnConstraint.constant = -30
        self.mainView?.searchBtnConstraint.constant = -30
        self.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let customView = Bundle.main.loadNibNamed("CDMainView", owner: self, options: nil)?.first as? CDMainView else {
            return
        }
        mainView = customView
        
        let nibCell = UINib(nibName: "CDFacilityCollectionViewCell", bundle: nil)
        mainView?.buildingCollection.register(nibCell, forCellWithReuseIdentifier: "facility")

        mapView = NMapView(frame: self.view.frame)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.setZoomEnabled(true)
            mapView.setClientId("KfDJpcLBqgmp2A1x_S9L")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        self.mainView?.mapContainer.addSubview(mapView!)
        self.view.addSubview(self.mainView!)
        self.mainView?.delegate = self
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setBuildingMarker() {
        if overlay != nil {
            overlay?.remove()
        }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude: 127.133214, latitude: 37.276055), atLevel: 12)
            
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
}

extension CDMainViewController: NMapPOIdataOverlayDelegate {
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
        mainView?.reverseViewsHidden()
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
        
        self.mainView?.viewsHiddenOff()
        self.mainView?.modifyBuildingInfo(buildingImage: UIImage(named: gpsInfo!.building!.bImage!)!, buildingName: gpsInfo!.building!.bName!)
        self.mainView?.buildingCollectionAdpater.facilities = facilitiesSet.array as! [Facility]
        self.mainView?.buildingCollection.reloadData()
        self.mainView?.gpsBtnConstraint.constant = -10 - mainView!.buildingInfoView.layer.frame.height
        self.mainView?.searchBtnConstraint.constant = -10 - mainView!.buildingInfoView.layer.frame.height

        self.mainView?.buildingInfoView.isHidden = false
        return nil
    }
}

extension CDMainViewController: NMapLocationManagerDelegate {
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

extension CDMainViewController: CDMainViewDelegate {
    
    func swipeOrtapBuildingInfo() {
        let building = CDCoreDataManager.store.selectBuilding(bName: self.mainView!.buildingName.text!)
        let buildingDetailVC = CDBuildingDetailViewController(nibName: "CDBuildingDetailViewController", bundle: nil)
        buildingDetailVC.building = building!
        
        CDParentNavigationController.sharedInstance.pushViewController(buildingDetailVC, animated: false)
        UIView.setAnimationTransition(.curlUp, for: buildingDetailVC.view, cache: false)
        UIView.setAnimationDuration(2)
        UIView.commitAnimations()
    }
    
    func getPathBtnClicked() {
        let getPathVC = CDGetPathViewController(nibName: "CDGetPathViewController", bundle: nil)
        CDParentNavigationController.sharedInstance.pushViewController(getPathVC, animated: true)
    }
    
    func arrivedBtnClicked() {
        let building = CDCoreDataManager.store.selectBuilding(bName: self.mainView!.buildingName.text!)
        let getPathVC = CDGetPathViewController(nibName: "CDGetPathViewController", bundle: nil)
        getPathVC.arrivedBuiling = building!
        
        CDParentNavigationController.sharedInstance.pushViewController(getPathVC, animated: true)
    }
    
    func startBtnClicked() {
        let building = CDCoreDataManager.store.selectBuilding(bName: self.mainView!.buildingName.text!)
        let getPathVC = CDGetPathViewController(nibName: "CDGetPathViewController", bundle: nil)
        getPathVC.startBuilding = building!
        
        CDParentNavigationController.sharedInstance.pushViewController(getPathVC, animated: true)
    }
    
    func searchingBtnClicked() {
        let searching = CDSearchingViewController(nibName: "CDSearchingViewController", bundle: nil)
        searching.delegate = self
        CDParentNavigationController.sharedInstance.pushViewController(searching, animated: false)
    }
    
    func zoomInBtnClicked() {
        self.mapView?.setZoomLevel((mapView?.zoomLevel())! + 1)
    }
    
    func zoomOutBtnClicked() {
        self.mapView?.setZoomLevel((mapView?.zoomLevel())! - 1)
    }
    
    func myLocationBtnClicked() {
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
            self.mainView?.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_default"), for: .normal)
        case .tracking:
            self.mainView?.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_active"), for: .normal)
        case .trackingWithHeading:
            self.mainView?.gpsBtn.setImage(#imageLiteral(resourceName: "userLocation_tracking"), for: .normal)
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

extension CDMainViewController: CDSearchingViewControllerDelegate {
    
    func buildingCellClicked(bName: String) {
        
        let building = CDCoreDataManager.store.selectBuilding(bName: bName)
        let layers = building?.layer?.array as! [Layers]
        let facilitiesSet = NSMutableOrderedSet()
        
        for layer in layers {
            for each in layer.eachLayerFacilities?.array as! [EachLayerFacilities] {
                facilitiesSet.add(each.facility!)
            }
        }
        
        self.mainView?.viewsHiddenOff()
        self.mainView?.modifyBuildingInfo(buildingImage: UIImage(named: building!.bImage!)!, buildingName: building!.bName!)
        self.mainView?.buildingCollectionAdpater.facilities = facilitiesSet.array as! [Facility]
        self.mainView?.buildingCollection.reloadData()
        self.mainView?.gpsBtnConstraint.constant = -10 - mainView!.buildingInfoView.layer.frame.height
        self.mainView?.searchBtnConstraint.constant = -10 - mainView!.buildingInfoView.layer.frame.height
        
        self.mainView?.buildingInfoView.isHidden = false

        
        if self.overlay != nil {
            self.overlay?.remove()
        }
        
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
    
    func facilityCellClicked(fName: String) {
        if self.overlay != nil {
            self.overlay?.remove()
        }
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                self.overlay = poiDataOverlay
                let buildingGpsInfos = CDCoreDataManager.store.selectAllCoreDataObjectFromBuilding()
                
                let selectedFacility = CDCoreDataManager.store.selectAllCoreDataObjectFromFacility().filter {
                    $0.fName == fName
                }.first!
                
                
                poiDataOverlay.initPOIdata(Int32(buildingGpsInfos.count))
                for building in buildingGpsInfos {
                    let layers = building.layer?.array as! [Layers]
                    for layer in layers {
                        var flag = false
                        let eachLayerFacilities = layer.eachLayerFacilities?.array as! [EachLayerFacilities]
                        for each in eachLayerFacilities {
                            if checkFacility(eachFacility: each.facility!, checkFacility: selectedFacility) {
                                let type = facilityNMapPOIflagType(fName: each.facility!.fName!)
                                
                                let lon = (building.gpsInfo?.array.first! as! GPSInfo).longitude
                                let lat = (building.gpsInfo?.array.first! as! GPSInfo).latitude
                                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: lon, latitude: lat), title: "title", type: type, iconIndex: 1, with : nil)
                                flag = true
                                break
                            }
                        }
                        if flag {
                            break
                        }
                    }
                }
                poiDataOverlay.endPOIdata()
                poiDataOverlay.showAllPOIdata()
            }
        }
    }
    
    func checkFacility(eachFacility: Facility, checkFacility: Facility) -> Bool {
        if checkFacility.fName == CDFacilities.fDisabledPublicToilet.rawValue {
            if eachFacility == checkFacility || eachFacility.fName == CDFacilities.fManToilet.rawValue || eachFacility.fName == CDFacilities.fWomanToilet.rawValue {
                return true
            }
            return false
        } else if checkFacility.fName == CDFacilities.fPublicToilet.rawValue {
            if eachFacility == checkFacility || eachFacility.fName == CDFacilities.fPublicToiletWoman.rawValue {
                return true
            }
            return false
        } else {
            if eachFacility == checkFacility {
                return true
            }
            return false
        }
    }
    
    func facilityNMapPOIflagType(fName: String) -> NMapPOIflagType {
        let facilityState = CDFacilities(rawValue: fName)!
        switch facilityState {
        case .fBell:
            return NMapPOIflagTypeBell
        case .fElevator:
            return NMapPOIflagTypeElevator
        case .fWomanToilet:
            return NMapPOIflagTypeDisabledToilet
        case .fManToilet:
            return NMapPOIflagTypeDisabledToilet
        case .fDisabledPublicToilet:
            return NMapPOIflagTypeDisabledToilet
        case .fPublicToilet:
            return NMapPOIflagTypePublicToilet
        case .fPublicToiletWoman:
            return NMapPOIflagTypePublicToilet
        case .fWheelchairReport:
            return NMapPOIflagTypeWheelChairReport
        case .fSlopeWay:
            return NMapPOIflagTypeSlope
        case .fRest:
            return NMapPOIflagTypeRest
        case .fDisabledRest:
            return NMapPOIflagTypeDisabledRest
        default:
            return NMapPOIflagTypeUnknown
        }
    }
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
