//
//  GPSInfo+CoreDataProperties.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 28..
//  Copyright © 2018년 user. All rights reserved.
//
//

import Foundation
import CoreData


extension GPSInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GPSInfo> {
        return NSFetchRequest<GPSInfo>(entityName: "GPSInfo")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var building: Building?
    @NSManaged public var nextConnection: NSMutableOrderedSet?

}

// MARK: Generated accessors for nextConnection
extension GPSInfo {

    @objc(insertObject:inNextConnectionAtIndex:)
    @NSManaged public func insertIntoNextConnection(_ value: Connection, at idx: Int)

    @objc(removeObjectFromNextConnectionAtIndex:)
    @NSManaged public func removeFromNextConnection(at idx: Int)

    @objc(insertNextConnection:atIndexes:)
    @NSManaged public func insertIntoNextConnection(_ values: [Connection], at indexes: NSIndexSet)

    @objc(removeNextConnectionAtIndexes:)
    @NSManaged public func removeFromNextConnection(at indexes: NSIndexSet)

    @objc(replaceObjectInNextConnectionAtIndex:withObject:)
    @NSManaged public func replaceNextConnection(at idx: Int, with value: Connection)

    @objc(replaceNextConnectionAtIndexes:withNextConnection:)
    @NSManaged public func replaceNextConnection(at indexes: NSIndexSet, with values: [Connection])

    @objc(addNextConnectionObject:)
    @NSManaged public func addToNextConnection(_ value: Connection)

    @objc(removeNextConnectionObject:)
    @NSManaged public func removeFromNextConnection(_ value: Connection)

    @objc(addNextConnection:)
    @NSManaged public func addToNextConnection(_ values: NSOrderedSet)

    @objc(removeNextConnection:)
    @NSManaged public func removeFromNextConnection(_ values: NSOrderedSet)

}
