//
//  DatabaseInitializerManager.swift
//  CACUTA
//  Created by Ehab Saifan on 6/9/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import SwiftCSV

class DatabaseInitializerManager: NSObject {
        
    static let currentManager = DatabaseInitializerManager()
    
    private var container = {
        return AppDelegate.persistentContainer
    }()
    
    override init() {
        super.init()
    }
    
    func initDataBase() {
        print("DB start initializing")
        self.container.performBackgroundTask { (context) in
            self.initCourses(context: context)
            self.initAreas(context: context)
            self.initUniversities(context: context)
        }
    }// initDataBase
    
    
    /// returns CSV file to get the data from
    /// otherwise it will return nil.
    /// - Parameter resourceName: name of the file in the bundle with the 'csv' extension
    /// - Returns: optinal CSV
    func getCSVFile(forResourse resourceName: CSVFile) -> CSV? {
        if let fileName = Bundle.main.path(forResource: resourceName.rawValue, ofType: "csv"){
            let url = URL(fileURLWithPath: fileName)
            if let csv = try? CSV(url: url as NSURL) {
                return csv
            }
            return nil
        }
        return nil
    }
    
    
    // IMPORT ALL COURSES
    private func initCourses(context: NSManagedObjectContext) {
        
        
            if let csv = self.getCSVFile(forResourse: CSVFile.ClassesList) {
                let rowsCount = csv.rows.count
                _ = csv.rows[0]      //=> [college: Deanza, title: Composition and Reading, sub_area: A, description: Introduction to university level reading and writing❤️ with an emphasis on analysis. Close examination of a variety of texts (personal❤️ popular❤️ literary❤️ professional❤️ academic) from culturally diverse traditions. Practice in common rhetorical strategies used in academic writing. Composition of clear❤️ well-organized❤️ and well-developed essays❤️ with varying purposes and differing audiences❤️ from personal to academic., area: 1, course_num: 1A, dept: EWRT, units: 5]
                
                /*
                 WHY THE HEARTS?
                 Comma-separated value files do not have a set standard, and the file gets breaken down wherever a comma exists. The ❤️ is merely used to replace in text commas from the .CSV file, and it will later be substituted to a comma after it is collected
                 */
                
                for i in 0..<rowsCount {
                    
                    let course = Course(context: context)
                    
                    course.college = csv.rows[i][College]
                    course.areaName = csv.rows[i][AREA]
                    course.subArea = csv.rows[i][SubArea]
                    course.department = csv.rows[i][Depart]
                    course.code = csv.rows[i][CourseNum]
                    let course_title = csv.rows[i][Name]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                    course.name = course_title
                    course.shouldBeDisplayed = true
                    let about = csv.rows[i][Descript]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                    course.about = about
                    course.numOfUnits = csv.rows[i][Units]
                    
                }// end for
//            }
            self.save(context: context)
            
        }// end CSV path for courses
    }// end initCourses
    
    
    // IMPORT ALL Areas
    private func initAreas(context: NSManagedObjectContext){
        
            if let csv = self.getCSVFile(forResourse: CSVFile.AreasList) {
                let rowsCount = csv.rows.count
                
                for i in 0..<rowsCount {
                    let area = Area(context: context)
                    area.name = csv.rows[i][Name]
                    area.title = csv.rows[i][Title]
                    area.minRequierdUnits = csv.rows[i][MinUnits]
                    area.about = csv.rows[i][Descript]
                    area.numOfSections = Int32(csv.rows[i][SectionsCount]!)!
                    let notes = csv.rows[i][Note]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                    area.notes = notes
                }// end for
                
                self.save(context: context)
            
        }// end CSV path for areas
    }// end initAreas
    
    // IMPORT ALL UNIVERSITIES
    private func initUniversities(context: NSManagedObjectContext){
        
            if let csv = self.getCSVFile(forResourse: CSVFile.UniversitiesList) {
                let rowsCount = csv.rows.count
                
                for i in 0..<rowsCount {
                    
                    let university = University(context: context)
                    
                    university.name = csv.rows[i][Name]
                    university.acronym = csv.rows[i][Acron]
                    university.establishmentYear = csv.rows[i][YearFounded]
                    university.admissionRate = (csv.rows[i][TransAdmRate]! as NSString).doubleValue
                    university.rank = csv.rows[i][USRank]
                    university.averageGPA = csv.rows[i][AGPA]
                    university.assistLink = csv.rows[i][Assist]
                    university.url = csv.rows[i][WebURL]
                    let university_description = csv.rows[i][Descript]?.replacingOccurrences(of:"❤️", with: ",", options:.literal, range: nil)
                    university.about = university_description
                }// end for
                
                self.save(context: context)
        }// end CSV path for universities
    }// end initUniversities
    
    
    /// Function to save the current context
    ///
    /// - Parameter context: the context in which the
    ///    changes has been done.
    private func save(context: NSManagedObjectContext){
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error.localizedDescription)")
        }// end catch
    }// end save
    
}







