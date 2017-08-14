//
//  FavoriteCourse+CoreDataClass.swift
//  CACUTA
//
//  Created by Ehab Saifan on 8/8/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation
import CoreData


public class FavoriteCourse: Course {
    
    static func createFavoriteCourse(from course: Course) -> FavoriteCourse {
        let favoriteCourse = FavoriteCourse(context: course.managedObjectContext!)
        favoriteCourse.name = course.name
        favoriteCourse.code = course.code
        favoriteCourse.about = course.about
        favoriteCourse.department = course.department
        favoriteCourse.area = course.area
        favoriteCourse.areaName = course.areaName
        favoriteCourse.subArea = course.subArea
        favoriteCourse.college = course.college
        favoriteCourse.numOfUnits = course.numOfUnits
        favoriteCourse.isTaken = false
        return favoriteCourse
    }
}
