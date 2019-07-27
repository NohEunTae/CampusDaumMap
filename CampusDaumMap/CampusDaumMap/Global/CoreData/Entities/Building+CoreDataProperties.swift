//
//  Building+CoreDataProperties.swift
//  
//
//  Created by user on 2018. 10. 4..
//
//

import Foundation
import CoreData


extension Building {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Building> {
        return NSFetchRequest<Building>(entityName: "Building")
    }

    @NSManaged public var bName: String?
    @NSManaged public var bImage: String?
    @NSManaged public var gpsInfo: NSMutableOrderedSet?
    @NSManaged public var layer: NSMutableOrderedSet?

}

// MARK: Generated accessors for gpsInfo
extension Building {

    @objc(insertObject:inGpsInfoAtIndex:)
    @NSManaged public func insertIntoGpsInfo(_ value: GPSInfo, at idx: Int)

    @objc(removeObjectFromGpsInfoAtIndex:)
    @NSManaged public func removeFromGpsInfo(at idx: Int)

    @objc(insertGpsInfo:atIndexes:)
    @NSManaged public func insertIntoGpsInfo(_ values: [GPSInfo], at indexes: NSIndexSet)

    @objc(removeGpsInfoAtIndexes:)
    @NSManaged public func removeFromGpsInfo(at indexes: NSIndexSet)

    @objc(replaceObjectInGpsInfoAtIndex:withObject:)
    @NSManaged public func replaceGpsInfo(at idx: Int, with value: GPSInfo)

    @objc(replaceGpsInfoAtIndexes:withGpsInfo:)
    @NSManaged public func replaceGpsInfo(at indexes: NSIndexSet, with values: [GPSInfo])

    @objc(addGpsInfoObject:)
    @NSManaged public func addToGpsInfo(_ value: GPSInfo)

    @objc(removeGpsInfoObject:)
    @NSManaged public func removeFromGpsInfo(_ value: GPSInfo)

    @objc(addGpsInfo:)
    @NSManaged public func addToGpsInfo(_ values: NSOrderedSet)

    @objc(removeGpsInfo:)
    @NSManaged public func removeFromGpsInfo(_ values: NSOrderedSet)

}

// MARK: Generated accessors for layer
extension Building {

    @objc(insertObject:inLayerAtIndex:)
    @NSManaged public func insertIntoLayer(_ value: Layers, at idx: Int)

    @objc(removeObjectFromLayerAtIndex:)
    @NSManaged public func removeFromLayer(at idx: Int)

    @objc(insertLayer:atIndexes:)
    @NSManaged public func insertIntoLayer(_ values: [Layers], at indexes: NSIndexSet)

    @objc(removeLayerAtIndexes:)
    @NSManaged public func removeFromLayer(at indexes: NSIndexSet)

    @objc(replaceObjectInLayerAtIndex:withObject:)
    @NSManaged public func replaceLayer(at idx: Int, with value: Layers)

    @objc(replaceLayerAtIndexes:withLayer:)
    @NSManaged public func replaceLayer(at indexes: NSIndexSet, with values: [Layers])

    @objc(addLayerObject:)
    @NSManaged public func addToLayer(_ value: Layers)

    @objc(removeLayerObject:)
    @NSManaged public func removeFromLayer(_ value: Layers)

    @objc(addLayer:)
    @NSManaged public func addToLayer(_ values: NSOrderedSet)

    @objc(removeLayer:)
    @NSManaged public func removeFromLayer(_ values: NSOrderedSet)

}
