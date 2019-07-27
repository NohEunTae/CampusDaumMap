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
    var item: NMapPOIitem?
    var overlay: NMapPOIdataOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        guard let customView = Bundle.main.loadNibNamed("CDMainView", owner: self, options: nil)?.first as? CDMainView else {
            return
        }
        mainView = customView

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
                    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: lon, latitude: lat), title: "", type: NMapPOIflagTypeBuilding, iconIndex: 0, with : nil)
                }
                poiDataOverlay.endPOIdata()
                poiDataOverlay.showAllPOIdata()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        print("poiitem : \(poiItem.location)")
        
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
    
    func searchingBtnClicked() {
        
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
