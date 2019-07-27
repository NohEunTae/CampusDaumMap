//
//  CDSetInitialCoreData.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData
func setInitialCoreData() {
    

//    let connection = CDCoreDataManager.store.selectAllCoreDataObjectFromConnection()
//    print("connection count : \(connection.count)")
//    for c in connection {
////        CDCoreDataManager.store.deleteFromConnectionWhere(connection: c)
//        print("\(c.nextGPS?.latitude) : \(c.nextGPS?.longitude) , \(c.weight) ")
//    }
//
//    print("gpsInfo count : \(gpsInfos.count)")
//    for g in gpsInfos {
//        CDCoreDataManager.store.deleteFromGPSInfoWhere(gpsInfo: g)
//        //        print("\(g.latitude) : \(g.longitude)")
//    }
//

//    CDCoreDataManager.store.insertIntoGPSInfo(latitude: 10, longitude: 100, bName: nil)
//    CDCoreDataManager.store.insertIntoGPSInfo(latitude: 20, longitude: 200, bName: nil)
//    CDCoreDataManager.store.insertIntoGPSInfo(latitude: 30, longitude: 300, bName: nil)
//    CDCoreDataManager.store.insertIntoGPSInfo(latitude: 40, longitude: 400, bName: nil)

//
////    CDCoreDataManager.store.insertIntoBuilding(bName: "샬롬")
////    CDCoreDataManager.store.insertIntoBuilding(bName: "인사")
////    CDCoreDataManager.store.insertIntoBuilding(bName: "우원")
//

//    let one = CDCoreDataManager.store.selectGPS(latitude: 10, longitude: 100)
//    let two = CDCoreDataManager.store.selectGPS(latitude: 20, longitude: 200)
//    let four = CDCoreDataManager.store.selectGPS(latitude: 30, longitude: 300)
//    let five = CDCoreDataManager.store.selectGPS(latitude: 40, longitude: 400)
//
//    CDCoreDataManager.store.insertIntoConnection(from: one!, to: five!, weight: 2)
//    CDCoreDataManager.store.insertIntoConnection(from: two!, to: four!, weight: 1)
//    CDCoreDataManager.store.insertIntoConnection(from: four!, to: five!, weight: 3)

    print("connection cnt : \(CDCoreDataManager.store.selectAllCoreDataObjectFromConnection().count)")
    let gpsInfos = CDCoreDataManager.store.selectAllCoreDataObjectFromGPSInfo()
    for gps in gpsInfos {
        print("one gps")
        print("\(gps.latitude), \(gps.longitude) to")
        for connection in gps.nextConnection!.array as! [Connection] {
            print("\(connection.nextGPS!.latitude), \(connection.nextGPS!.longitude), w : \(connection.weight)")
        }
    }
}


func removeAllOfCoreData() {
    removeGPSInfo()
    removeConnection()
    removeBuilding()
    removeFacility()
    removeEachLayerFacilities()
    removeLayers()
}

func removeConnection() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Connection")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)

    } catch {

    }
}

func removeGPSInfo() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GPSInfo")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeBuilding() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Building")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeLayers() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Layers")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeFacility() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Facility")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}

func removeEachLayerFacilities() {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "LayerFacilities")
    let request = NSBatchDeleteRequest(fetchRequest: fetch)
    do {
        let _ = try CDCoreDataManager.store.managedObjectContext.execute(request)
        
    } catch {
        
    }
}



