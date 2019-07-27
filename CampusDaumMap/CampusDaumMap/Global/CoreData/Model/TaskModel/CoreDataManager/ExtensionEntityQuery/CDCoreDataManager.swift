//
//  CDCoreDataManager.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 25..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

final class CDCoreDataManager {
    static let store = CDCoreDataManager()

    var managedObjectContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! CDAppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var saveIfCanSave: Bool {
        do {
            try managedObjectContext.save()
            print("[info] .... Save Successfully")
            return true
        } catch _ as NSError {
            print("[info] .... Save Function Failed")
        }
        return false
    }

    @discardableResult func executeGPSInfoQuery<T>(query: (NSFetchRequest<GPSInfo>) -> T) -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: "GPSInfo", in: managedObjectContext)
        let request: NSFetchRequest<GPSInfo> = GPSInfo.fetchRequest()
        request.entity = entityDescription
        return query(request)
    }
    
    @discardableResult func executeConnectionQuery<T>(query: (NSFetchRequest<Connection>) -> T) -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Connection", in: managedObjectContext)
        let request: NSFetchRequest<Connection> = Connection.fetchRequest()
        request.entity = entityDescription
        
        return query(request)
    }
    
    @discardableResult func executeBuildingQuery<T>(query: (NSFetchRequest<Building>) -> T) -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Building", in: managedObjectContext)
        let request: NSFetchRequest<Building> = Building.fetchRequest()
        request.entity = entityDescription
        
        return query(request)
    }
    
    @discardableResult func executeFacilityQuery<T>(query: (NSFetchRequest<Facility>) -> T) -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Facility", in: managedObjectContext)
        let request: NSFetchRequest<Facility> = Facility.fetchRequest()
        request.entity = entityDescription
        
        return query(request)
    }
    
    @discardableResult func executeEachLayerFacilitiesQuery<T>(query: (NSFetchRequest<EachLayerFacilities>) -> T) -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: "EachLayerFacilities", in: managedObjectContext)
        let request: NSFetchRequest<EachLayerFacilities> = EachLayerFacilities.fetchRequest()
        request.entity = entityDescription
        
        return query(request)
    }
    
    @discardableResult func executeLayersQuery<T>(query: (NSFetchRequest<Layers>) -> T) -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Layers", in: managedObjectContext)
        let request: NSFetchRequest<Layers> = Layers.fetchRequest()
        request.entity = entityDescription
        
        return query(request)
    }
}
