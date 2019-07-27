//
//  EachLayerFacilities+CoreDataProperties.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 27..
//  Copyright © 2018년 user. All rights reserved.
//
//

import Foundation
import CoreData


extension EachLayerFacilities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EachLayerFacilities> {
        return NSFetchRequest<EachLayerFacilities>(entityName: "EachLayerFacilities")
    }

    @NSManaged public var layers: Layers?
    @NSManaged public var facility: Facility?

}
