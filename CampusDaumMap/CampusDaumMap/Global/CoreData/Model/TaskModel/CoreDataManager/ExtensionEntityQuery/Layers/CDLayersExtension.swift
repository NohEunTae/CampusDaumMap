//
//  CDLayersExtension.swift
//  CampusDaumMap
//
//  Created by user on 2018. 9. 28..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Manage Layers Core Data

extension CDCoreDataManager {
    @discardableResult func insertIntoLayers(stairNumb: Int, imageName: String?, building: Building) -> Layers? {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Layers", in: managedObjectContext)
        let contact = Layers(entity: entityDescription!, insertInto: managedObjectContext)
        
        let isExist = selectAllCoreDataObjectFromLayers().filter { $0.building == building && $0.stairNumb == Int32(stairNumb) }.first
        guard isExist == nil else {
            print("[Error Layers Insert] .... Data already exist")
            return nil
        }
        
        contact.imageName = imageName
        contact.building = building
        contact.stairNumb = Int32(stairNumb)
        building.layer?.add(contact)
        
        if saveIfCanSave {
            return contact
        }
        
        return nil
    }
    
    @discardableResult func selectAllCoreDataObjectFromLayers() -> [Layers] {
        var layers = [Layers]()
        
        return executeLayersQuery { (request) -> [Layers] in
            do {
                let objects = try managedObjectContext.fetch(request)
                for object in objects {
                    if object.stairNumb != Int32(0) {
                        layers.append(object)
                    }
                }
            } catch _ as NSError  {
                print("[Error Layers select All] .... ManagedObjectContext find function failed")
            }
            return layers
        }
    }
    
    @discardableResult func updateLayersSet(stairNumb: Int, imageName: String?, building: Building, origin: Layers) -> Bool {
        let updateLayers = selectAllCoreDataObjectFromLayers().filter { $0.stairNumb == stairNumb && $0.building == building }.first
        
        guard updateLayers == nil else {
            print("[Error Layers Update] .... Layer already exist")
            return false
        }
        origin.building?.layer?.remove(origin)
        origin.building = building
        building.layer?.add(origin)
        origin.imageName = imageName
        origin.stairNumb = Int32(stairNumb)

        return saveIfCanSave
    }
    
    @discardableResult func deleteFromLayersWhere(layers: Layers) -> Bool {
        managedObjectContext.delete(layers)
        return saveIfCanSave
    }
}
