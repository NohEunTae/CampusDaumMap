//
//  GPSInfoExtension.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Manage GPSInfo Core Data
extension CDCoreDataManager {
    @discardableResult func insertIntoGPSInfo(latitude: Double, longitude: Double, bName: String?) -> Bool {
        let entityDescription = NSEntityDescription.entity(forEntityName: "GPSInfo", in: managedObjectContext)
        let contact = GPSInfo(entity: entityDescription!, insertInto: managedObjectContext)
        
        guard selectGPS(latitude: latitude, longitude: longitude) == nil else {
            print("[Error GPSInfo Insert Info] .... Data already exist")
            return false
        }
        
        contact.longitude = longitude
        contact.latitude = latitude
        let buidling = selectAllCoreDataObjectFromBuilding().filter { $0.bName == bName }.first
        
        contact.building = buidling
        buidling?.gpsInfo?.add(contact)
        
        return saveIfCanSave
    }
    
    @discardableResult func selectAllCoreDataObjectFromGPSInfo() -> [GPSInfo] {
        var gpsInfos = [GPSInfo]()
        return executeGPSInfoQuery { (request) -> [GPSInfo] in
            do {
                let objects = try managedObjectContext.fetch(request)
                for object in objects {
                    if object.latitude != 0, object.longitude != 0 {
                        gpsInfos.append(object)
                    }
                }
            } catch _ as NSError  {
                print("[Error GPSInfo Select All] .... ManagedObjectContext find function failed!!")
            }

            return gpsInfos
        }
    }
    
    @discardableResult func selectGPS(latitude: Double, longitude: Double) -> GPSInfo? {
        let gpsInfo = selectAllCoreDataObjectFromGPSInfo().filter { $0.latitude == latitude && $0.longitude == longitude }.first
        
        return gpsInfo
    }
    
    @discardableResult func updateGPSInfoSet(latitude: Double, longitude: Double, bName: String?, origin: GPSInfo) -> Bool {
        let value = selectAllCoreDataObjectFromGPSInfo().filter { $0.latitude == latitude && $0.longitude == longitude }.first
        
        guard value == nil else {
            print("[Error GPSInfo Update] .... Update GPS is already exist")
            return false
        }
        
        if bName != nil {
            let building = selectAllCoreDataObjectFromBuilding().filter { $0.bName == bName }.first
            guard let validBuilding = building else {
                print("[Error GPSInfo Update] .... Update Building is not exist")
                return false
            }
            origin.building = validBuilding
            validBuilding.gpsInfo?.add(origin)
        }
        
        let originBuilding = selectAllCoreDataObjectFromBuilding().filter { $0 == origin.building }.first
        originBuilding?.gpsInfo?.remove(origin)

        origin.latitude = latitude
        origin.longitude = longitude

        
        return saveIfCanSave
    }
    
    @discardableResult func deleteFromGPSInfoWhere(gpsInfo: GPSInfo) -> Bool {
        managedObjectContext.delete(gpsInfo)
        return saveIfCanSave
    }
}
