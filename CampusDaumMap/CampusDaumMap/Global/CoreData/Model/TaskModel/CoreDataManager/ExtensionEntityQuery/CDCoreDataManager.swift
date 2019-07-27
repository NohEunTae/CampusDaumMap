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
        let entityDescription = NSEntityDescription.entity(forEntityName: "Facility", in: managedObjectContext)
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

// MARK: - Manage GPSInfo Core Data
extension CDCoreDataManager {
    @discardableResult func insertIntoGPSInfo(value: CDGPSInfoModel) -> Bool {
        let entityDescription = NSEntityDescription.entity(forEntityName: "GPSInfo", in: managedObjectContext)
        let contact = GPSInfo(entity: entityDescription!, insertInto: managedObjectContext)
        contact.longitude = value.longitude
        contact.latitude = value.latitude
        contact.bName = value.bName
        return saveIfCanSave
    }
    
    @discardableResult func selectAllObjectFromGPSInfo() -> NSArray {
        let gpsInfos: NSMutableArray = NSMutableArray()
        return executeGPSInfoQuery { (request) -> NSArray in
            do {
                let objects = try managedObjectContext.fetch(request)
                if objects.count > 0 {
                    print("FindContact => Data founded!!")
                    for object in objects {
                        if let latitude = object.value(forKey: "latitude") as? Double,
                            let longitude = object.value(forKey: "longitude") as? Double,
                            let bName = object.value(forKey: "bName") as? String {
                            
                            let gpsInfo: CDGPSInfoModel = CDGPSInfoModel(latitude, longitude, bName)
                            gpsInfos.add(gpsInfo)
                        }
                    }
                } else {
                    print("FindContact => Nothing founded!!")
                }
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
            }
            return gpsInfos
        }
    }
    
    @discardableResult func updateGPSInfoSet(valueGPS: CDGPSInfoModel, where latitude: Double, _ longitude: Double) -> Bool {
        return executeGPSInfoQuery(query: { (request) -> Bool in
            do {
                let objects = try managedObjectContext.fetch(request)
                let match = objects.filter {$0.latitude == latitude && $0.longitude == longitude }.first
                guard match != nil else {
                    print("[info] .... can't find \(latitude) : \(longitude) gps")
                    return false
                }
                
                match?.setValue(valueGPS.bName, forKey: "bName")
                if match?.latitude != valueGPS.latitude || match?.longitude != valueGPS.longitude {
                    let isUpdateDataIsExist = objects.filter {$0.latitude == valueGPS.latitude && $0.longitude == valueGPS.longitude }.first
                    
                    guard isUpdateDataIsExist == nil else {
                        print("[info] .... \(String(describing: valueGPS)) category is already exist")
                        return false
                    }
                    match?.setValue(valueGPS.latitude, forKey: "latitude")
                    match?.setValue(valueGPS.longitude, forKey: "longitude")
                }
                
                try managedObjectContext.save()
                print("[info] .... Save Successfully")
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
                return false
            }
            
            return true
        })
        
    }
    
    @discardableResult func deleteFromGPSInfoWhere(latitude: Double, longitude: Double) -> Bool {
        return executeGPSInfoQuery(query: { (request) -> Bool in
            do {
                let objects = try managedObjectContext.fetch(request)
                let match = objects.filter {$0.latitude == latitude && $0.longitude == longitude}.first
                guard match != nil else {
                    print("[info] .... \(latitude) : \(longitude) gps is not exist so delete failed")
                    return false
                }
                managedObjectContext.delete(match!)
                try managedObjectContext.save()
                print("[info] .... Delete Successfully")
                return true
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
                return false
            }
        })
    }
}

// MARK: - Manage Connection Core Data
extension CDCoreDataManager {
    @discardableResult func insertIntoConnection(value: CDConnectionModel) -> Bool {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Connection", in: managedObjectContext)
        let contact = Connection(entity: entityDescription!, insertInto: managedObjectContext)
        
        executeGPSInfoQuery(query: { (request) -> GPSInfo? in
            do {
                let objects = try managedObjectContext.fetch(request)
                let match = objects.filter { $0 == value.firstGPS }.first
                guard match != nil else {
                    print("FindContact => Nothing founded!!")
                    return nil
                }
                contact.firstGPS = match
                return match
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
                return nil
            }
        })
        
        executeGPSInfoQuery(query: { (request) -> GPSInfo? in
            do {
                let objects = try managedObjectContext.fetch(request)
                let match = objects.filter { $0 == value.nextGPS }.first
                guard match != nil else {
                    print("FindContact => Nothing founded!!")
                    return nil
                }
                contact.nextGPS = match
                return match
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
                return nil
            }
        })
        contact.weight = value.weight
        
        return saveIfCanSave
    }
    
    @discardableResult func selectAllObjectFromConnection() -> NSArray {
        let connections: NSMutableArray = NSMutableArray()
        return executeConnectionQuery { (request) -> NSArray in
            do {
                let objects = try managedObjectContext.fetch(request)
                if objects.count > 0 {
                    print("FindContact => Data founded!!")
                    for object in objects {
                        if let firstGPS = object.value(forKey: "firstGPS") as? GPSInfo,
                            let nextGPS = object.value(forKey: "nextGPS") as? GPSInfo,
                            let weight = object.value(forKey: "weight") as? Double {
                            
                            let allGPSInfo = selectAllObjectFromGPSInfo() as! [CDGPSInfoModel]
                            let first = allGPSInfo.filter { $0.longitude == firstGPS.longitude && $0.latitude == firstGPS.latitude}.first
                            
                            let next = allGPSInfo.filter { $0.longitude == nextGPS.longitude && $0.latitude == nextGPS.latitude}.first
                            
                            let connection = CDConnectionModel(weight, first!, next!)
                            connections.add(connection)
                        }
                    }
                } else {
                    print("FindContact => Nothing founded!!")
                }
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
            }
            return connections
        }
    }
    
    @discardableResult func deleteFromConnectionWhere(connection: CDConnectionModel) -> Bool {
        return executeGPSInfoQuery(query: { (request) -> Bool in
            do {
                let objects = try managedObjectContext.fetch(request)
                let match = objects.filter {$0 == connection }.first
                guard match != nil else {
                    print("[info] .... \(connection) connection is not exist so delete failed")
                    return false
                }
                managedObjectContext.delete(match!)
                try managedObjectContext.save()
                print("[info] .... Delete Successfully")
                return true
            } catch _ as NSError  {
                print("findContact => managedObjectContext find function failed!!")
                return false
            }
        })
    }
}
