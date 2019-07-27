//
//  CDConnectionExtension.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Manage Connection Core Data
extension CDCoreDataManager {
    @discardableResult func insertIntoConnection(from: GPSInfo, to: GPSInfo, weight: Double) -> Bool {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Connection", in: managedObjectContext)
        let contact = Connection(entity: entityDescription!, insertInto: managedObjectContext)

        let isExist = selectAllCoreDataObjectFromConnection().filter {$0.fromGPS == from && $0.nextGPS == to}.first
        guard isExist == nil else {
            print("[Error Connection Insert] .... Connection already exist")
            return false
        }
        
        contact.nextGPS = to
        contact.fromGPS = from
        contact.weight = weight
        
        from.nextConnection?.add(contact)
      
        return saveIfCanSave
    }
    
    @discardableResult func selectAllCoreDataObjectFromConnection() -> [Connection] {
        var connections = [Connection]()
        return executeConnectionQuery { (request) -> [Connection] in
            do {
                let objects = try managedObjectContext.fetch(request)
                for object in objects {
                    if object.nextGPS != nil, object.weight != 0 {
                        connections.append(object)
                    }
                }
            } catch _ as NSError  {
                print("[Error Connection Select All] .... ManagedObjectContext find function failed")
            }
            return connections
        }
    }
    
    @discardableResult func deleteFromConnectionWhere(connection: Connection) -> Bool {
        managedObjectContext.delete(connection)
        return saveIfCanSave
    }
}
