//
//  Area+CoreDataClass.swift
//  CACUTA
//
//  Created by Ehab Saifan on 8/8/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import CoreData


public class Area: NSManagedObject {

    static func getDict(context: NSManagedObjectContext) -> [String: Int] {
        
        var areaDict: [String: Int] = [:]
        
        let fetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: AreaName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let areas = try context.fetch(fetchRequest)
            for area in areas {
                if let name = area.name, let minUnits = area.minRequierdUnits, let units = Int(minUnits){
                    areaDict[name] = units
                }
            }
        }catch let error as NSError{
            print("Could not fetch Areas: \(error.localizedDescription)")
        }
        return areaDict
    }
}
