//
//  CDBuildingExtension.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Manage Building Core Data
extension CDCoreDataManager {
    @discardableResult func insertIntoBuilding(bName: String, bImage: String) -> Bool {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Building", in: managedObjectContext)
        let contact = Building(entity: entityDescription!, insertInto: managedObjectContext)
        
        guard selectBuilding(bName: bName) == nil else {
            print("[Error Building Insert] .... Data already exist")
            return false
        }
        contact.bName = bName
        contact.bImage = bImage
        return saveIfCanSave
    }
    
    @discardableResult func selectAllCoreDataObjectFromBuilding() -> [Building] {
        var buildings = [Building]()
        
        return executeBuildingQuery { (request) -> [Building] in
            do {
                let objects = try managedObjectContext.fetch(request)
                for object in objects {
                    if object.bName != nil {
                        buildings.append(object)
                    }
                }
            } catch _ as NSError  {
                print("[Error Building select All] .... ManagedObjectContext find function failed")
            }
            return buildings
        }
    }
    
    @discardableResult func selectBuilding(bName: String) -> Building? {
        let building = selectAllCoreDataObjectFromBuilding().filter { $0.bName == bName }.first
        return building
    }

    @discardableResult func updateBuildingSet(bName: String,  origin: Building) -> Bool {
        let updateBuilding = selectAllCoreDataObjectFromBuilding().filter { $0.bName == bName }.first
        guard updateBuilding == nil else {
            print("[Error Building Update] .... Building is already exist")
            return false
        }
        origin.bName = bName
        return saveIfCanSave
    }

    @discardableResult func deleteFromBuildingWhere(building: Building) -> Bool {
        managedObjectContext.delete(building)
        return saveIfCanSave
    }
}
