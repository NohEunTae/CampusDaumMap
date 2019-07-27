//
//  Connection+CoreDataProperties.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 28..
//  Copyright © 2018년 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Connection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Connection> {
        return NSFetchRequest<Connection>(entityName: "Connection")
    }

    @NSManaged public var weight: Double
    @NSManaged public var nextGPS: GPSInfo?
    @NSManaged public var fromGPS: GPSInfo?
}
