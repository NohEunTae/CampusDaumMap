//
//  NMapViewResources.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 25..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

let UserPOIflagTypeDefault: NMapPOIflagType = NMapPOIflagTypeReserved + 1
let UserPOIflagTypeInvisible: NMapPOIflagType = NMapPOIflagTypeReserved + 2

class NMapViewResources: NSObject {
    
    open static func imageWithType(_ poiFlagType: NMapPOIflagType, selected: Bool) -> UIImage? {
        switch poiFlagType {
        case NMapPOIflagTypeLocation:
            return #imageLiteral(resourceName: "pubtrans_ic_mylocation_on")
        case NMapPOIflagTypeLocationOff:
            return #imageLiteral(resourceName: "pubtrans_ic_mylocation_off")
        case NMapPOIflagTypeCompass:
            return #imageLiteral(resourceName: "ic_angle")
        case UserPOIflagTypeDefault:
            return #imageLiteral(resourceName: "pubtrans_exact_default")
        case UserPOIflagTypeInvisible:
            return #imageLiteral(resourceName: "1px_dot")
        default:
            return nil
        }
    }
    
    open static func anchorPoint(withType type: NMapPOIflagType) -> CGPoint {
        switch type {
        case NMapPOIflagTypeLocation: fallthrough
        case NMapPOIflagTypeLocationOff: fallthrough
        case NMapPOIflagTypeCompass:
            return CGPoint(x: 0.5, y: 0.5)
        case UserPOIflagTypeDefault:
            return CGPoint(x: 0.5, y: 1.0)
        case UserPOIflagTypeInvisible:
            return CGPoint(x: 0.5, y: 0.5)
        default:
            return CGPoint(x: 0.5, y: 0.5)
        }
    }
}
