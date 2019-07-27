//
//  Layers+CoreDataProperties.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 28..
//  Copyright © 2018년 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Layers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Layers> {
        return NSFetchRequest<Layers>(entityName: "Layers")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var stairNumb: Int32
    @NSManaged public var building: Building?
    @NSManaged public var eachLayerFacilities: NSMutableOrderedSet?

}

// MARK: Generated accessors for eachLayerFacilities
extension Layers {

    @objc(insertObject:inEachLayerFacilitiesAtIndex:)
    @NSManaged public func insertIntoEachLayerFacilities(_ value: EachLayerFacilities, at idx: Int)

    @objc(removeObjectFromEachLayerFacilitiesAtIndex:)
    @NSManaged public func removeFromEachLayerFacilities(at idx: Int)

    @objc(insertEachLayerFacilities:atIndexes:)
    @NSManaged public func insertIntoEachLayerFacilities(_ values: [EachLayerFacilities], at indexes: NSIndexSet)

    @objc(removeEachLayerFacilitiesAtIndexes:)
    @NSManaged public func removeFromEachLayerFacilities(at indexes: NSIndexSet)

    @objc(replaceObjectInEachLayerFacilitiesAtIndex:withObject:)
    @NSManaged public func replaceEachLayerFacilities(at idx: Int, with value: EachLayerFacilities)

    @objc(replaceEachLayerFacilitiesAtIndexes:withEachLayerFacilities:)
    @NSManaged public func replaceEachLayerFacilities(at indexes: NSIndexSet, with values: [EachLayerFacilities])

    @objc(addEachLayerFacilitiesObject:)
    @NSManaged public func addToEachLayerFacilities(_ value: EachLayerFacilities)

    @objc(removeEachLayerFacilitiesObject:)
    @NSManaged public func removeFromEachLayerFacilities(_ value: EachLayerFacilities)

    @objc(addEachLayerFacilities:)
    @NSManaged public func addToEachLayerFacilities(_ values: NSOrderedSet)

    @objc(removeEachLayerFacilities:)
    @NSManaged public func removeFromEachLayerFacilities(_ values: NSOrderedSet)

}
