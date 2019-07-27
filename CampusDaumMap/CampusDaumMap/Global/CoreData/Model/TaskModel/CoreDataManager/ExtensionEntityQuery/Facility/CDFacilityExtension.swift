//
//  CDFacilityExtension.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 28..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Manage Facility Core Data

extension CDCoreDataManager {
    @discardableResult func insertIntoFacility(fName: String, iconName: String) -> Facility? {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Facility", in: managedObjectContext)
        let contact = Facility(entity: entityDescription!, insertInto: managedObjectContext)
        
        let isExist = selectAllCoreDataObjectFromFacility().filter { $0.fName == fName }.first
        guard isExist == nil else {
            print("[Error Facility Insert] .... Data already exist")
            return nil
        }
        
        contact.fName = fName
        contact.iconName = iconName
        
        if saveIfCanSave {
            return contact
        }
        return nil
    }
    
    @discardableResult func selectAllCoreDataObjectFromFacility() -> [Facility] {
        var facilities = [Facility]()
        
        return executeFacilityQuery { (request) -> [Facility] in
            do {
                let objects = try managedObjectContext.fetch(request)
                for object in objects {
                    if object.fName != nil, object.iconName != nil {
                        facilities.append(object)
                    }
                }
            } catch _ as NSError  {
                print("[Error Facility select All] .... ManagedObjectContext find function failed")
            }
            return facilities
        }
    }
    
    @discardableResult func updateFacilitySet(fName: String, iconName: String, origin: Facility) -> Bool {
        let updateFacility = selectAllCoreDataObjectFromFacility().filter { $0.fName == fName }.first
        
        guard updateFacility == nil else {
            print("[Error Facility Update] .... Layer already exist")
            return false
        }
        
        origin.fName = fName
        origin.iconName = iconName
        return saveIfCanSave
    }
    
    @discardableResult func deleteFromFacilityWhere(facility: Facility) -> Bool {
        managedObjectContext.delete(facility)
        return saveIfCanSave
    }
}
