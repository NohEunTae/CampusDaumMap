//
//  ViewController.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 25..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NMapViewDelegate, NMapPOIdataOverlayDelegate {
    var mapView: NMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NMapView(frame: self.view.frame)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.setClientId("KfDJpcLBqgmp2A1x_S9L")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(mapView)
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
            mapView.setMapCenter(NGeoPoint(longitude: 127.129161, latitude:37.273562), atLevel:11)
            
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
}

