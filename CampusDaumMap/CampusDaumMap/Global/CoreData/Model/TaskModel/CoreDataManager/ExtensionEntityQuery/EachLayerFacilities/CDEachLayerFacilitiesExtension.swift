//
//  CDEachLayerFacilitiesExtension.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 28..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Manage EachLayerFacilities Core Data

extension CDCoreDataManager {
    @discardableResult func insertIntoEachLayerFacilities(facility: Facility, layer: Layers) -> Bool {
        let entityDescription = NSEntityDescription.entity(forEntityName: "EachLayerFacilities", in: managedObjectContext)
        let contact = EachLayerFacilities(entity: entityDescription!, insertInto: managedObjectContext)
        
        let isExist = selectAllCoreDataObjectFromEachLayerFacilities().filter { $0.facility == facility && $0.layers == layer }.first
        
        guard isExist == nil else {
            print("[Error EachLayerFacilities Insert] .... Data already exist")
            return false
        }
        contact.facility = facility
        contact.layers = layer
        
        facility.eachLayerFacilities?.add(contact)
        layer.eachLayerFacilities?.add(contact)
        
        return saveIfCanSave
    }
    
    @discardableResult func selectAllCoreDataObjectFromEachLayerFacilities() -> [EachLayerFacilities] {
        var eachLayerFacilities = [EachLayerFacilities]()
        
        return executeEachLayerFacilitiesQuery { (request) -> [EachLayerFacilities] in
            do {
                let objects = try managedObjectContext.fetch(request)
                for object in objects {
                    if object.facility != nil, object.layers != nil {
                        eachLayerFacilities.append(object)
                    }
                }
            } catch _ as NSError  {
                print("[Error EachLayerFacilities select All] .... ManagedObjectContext find function failed")
            }
            return eachLayerFacilities
        }
    }
    
    @discardableResult func updateEachLayerFacilitiesSet(facility: Facility, layer: Layers, origin : EachLayerFacilities) -> Bool {
        
        let updateFacility = selectAllCoreDataObjectFromEachLayerFacilities().filter { $0.facility == facility && $0.layers == layer }.first
        
        guard updateFacility == nil else {
            print("[Error EachLayerFacilities Update] .... Layer already exist")
            return false
        }
        
        origin.facility?.eachLayerFacilities?.remove(origin)
        origin.layers?.eachLayerFacilities?.remove(origin)

        origin.facility = facility
        origin.layers = layer
        
        facility.eachLayerFacilities?.add(origin)
        layer.eachLayerFacilities?.add(origin)

        
        return saveIfCanSave
    }
    
    @discardableResult func deleteFromEachLayerFacilitiesWhere(eachLayerFacilities: EachLayerFacilities) -> Bool {
        managedObjectContext.delete(eachLayerFacilities)
        return saveIfCanSave
    }
}
