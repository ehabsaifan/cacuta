//
//  DataSourceManager.swift
//  UTA//
//  Created by Ehab Saifan on 6/9/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import SwiftCSV

class DataSourceManager: NSObject {
    
    fileprivate var objList: [NSManagedObject] = []
    
    static let currentManager = DataSourceManager()
    
    fileprivate var managedContext: NSManagedObjectContext = {
        //1
        return AppDelegate.viewContext
    }()
    
    override init() {
        super.init()
    }
    
    func initDataBase() {
        self.initAreas()
        self.initUniversities()
        self.initCourses()
        self.createRelations()
        
        print("Initializing DB")
        
    }// initDataBase
    
    fileprivate func initCourses() {
        // IMPORT ALL COURSES
        if let classesURL  = Bundle.main.path(forResource: "ClassesList", ofType: "csv"), let csvURL:URL = URL(fileURLWithPath: classesURL), let csv = try? CSV(url: csvURL as NSURL) {
            
            // Rows
            let rowsCount = csv.rows.count
            _ = csv.rows[0]      //=> [college: Deanza, title: Composition and Reading, sub_area: A, description: Introduction to university level reading and writing❤️ with an emphasis on analysis. Close examination of a variety of texts (personal❤️ popular❤️ literary❤️ professional❤️ academic) from culturally diverse traditions. Practice in common rhetorical strategies used in academic writing. Composition of clear❤️ well-organized❤️ and well-developed essays❤️ with varying purposes and differing audiences❤️ from personal to academic., area: 1, course_num: 1A, dept: EWRT, units: 5]
            
            /*
             WHY THE HEARTS?
             Comma-separated value files do not have a set standard, and the file gets breaken down wherever a comma exists. The ❤️ is merely used to replace in text commas from the .CSV file, and it will later be substituted to a comma after it is collected
             */
                
                for i in 0..<rowsCount {
                   
                    let course = Course(context: self.managedContext)
                    //3
                    // Get course college
                    course.college = csv.rows[i][College]
                    // Get course area
                    course.areaName = csv.rows[i][AREA]
                    // Get course sub-area
                    course.subArea = csv.rows[i][SubArea]
                    // Get course department
                    course.department = csv.rows[i][Depart]
                    // Get course number
                    course.code = csv.rows[i][CourseNum]
                    
                    // Get course title
                    let course_title = csv.rows[i][Name]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                    course.title = course_title
                    
                    // Get course description
                    let about = csv.rows[i][Descript]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                    course.about = about
                    
                    // Get course units
                    course.numOfUnits = csv.rows[i][Units]
                    
                }// end for
            //4
            print("Saving Courses")
            self.saveManagedContext()
            
        }// end CSV path for courses
    }// end initCourses
    
    fileprivate func initUniversities(){
        // IMPORT ALL UNIVERSITIES
        if let UniversitiesURL = Bundle.main.path(forResource: "UniversitiesList", ofType: "csv"), let csvURL:URL = URL(fileURLWithPath: UniversitiesURL), let csv = try? CSV(url: csvURL as NSURL) {
            
            // Rows
            let rowsCount = csv.rows.count
            //2
            let universityEntity =  NSEntityDescription.entity(forEntityName: Entities.University.rawValue, in:self.managedContext)
            
            for i in 0..<rowsCount {
                
                let university = NSManagedObject(entity: universityEntity!, insertInto: self.managedContext)
                
                //3
                // Get univ name
                university.setValue(csv.rows[i][Name], forKey: UnivName)
                // Get univ acronym
                university.setValue(csv.rows[i][Acron], forKey: UnivAcron)
                // Get univ establishment year
                university.setValue(csv.rows[i][YearFounded], forKey: UnivEstab)
                // Get univ transfer_admission_rate
                university.setValue((csv.rows[i][TransAdmRate]! as NSString).doubleValue, forKey: UnivAdmRate)
                // Get univ us_rank
                university.setValue(csv.rows[i][USRank], forKey: UnivRank)
                // Get univ average_gpa
                university.setValue(csv.rows[i][AGPA], forKey: UnivAGPA)
                // Get univ assist
                university.setValue(csv.rows[i][Assist], forKey: UnivAssist)
                // Get univ web_address
                university.setValue(csv.rows[i][WebURL], forKey: UnivURL)
                // Get course description
                let university_description = csv.rows[i][Descript]?.replacingOccurrences(of:"❤️", with: ",", options:.literal, range: nil)
                university.setValue(university_description, forKey: UnivDescript)
                
            }// end for
            
            //4
            print("Saving Universities")
            self.saveManagedContext()
            
        }// end CSV path for universities
    }// end initUniversities
    
    fileprivate func initAreas(){
        // IMPORT ALL Areas
        if let AreasURL = Bundle.main.path(forResource: "AreasList", ofType: "csv"), let csvURL:URL = URL(fileURLWithPath: AreasURL), let csv = try? CSV(url: csvURL as NSURL) {
            
            // Rows
            let rowsCount = csv.rows.count
            //2
            let areaEntity =  NSEntityDescription.entity(forEntityName: Entities.Area.rawValue, in:self.managedContext)
            
            for i in 0..<rowsCount {
                
                let area = NSManagedObject(entity: areaEntity!, insertInto: self.managedContext)
                
                //3
                // Get area name
                area.setValue(csv.rows[i][Name], forKey: AreaName)
                // Get area title
                area.setValue(csv.rows[i][Title], forKey: AreaTitle)
                // Get area minUnits
                area.setValue(csv.rows[i][MinUnits], forKey: AreaMinUnits)
                // Get description
                area.setValue(csv.rows[i][Descript], forKey: AreaDescript)
                // Get Sections Count
                area.setValue((csv.rows[i][SectionsCount]! as NSString).integerValue, forKey: AreaSecCount)
                // Get area note
                let notes = csv.rows[i][Note]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                area.setValue(notes, forKey: AreaNote)
                
            }// end for
            
            //4
            print("Saving Areas")
            self.saveManagedContext()
            
        }// end CSV path for areas
    }// end initAreas
    
    
    fileprivate func createRelations() {
        // Fetching Areas
        self.objList = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.Area.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let areas =
                try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for area in areas {
                // get area name
                if let areaname = area.value(forKey: AreaName) as? String {
                    print("\(areaname)")
                    // Fetching Courses
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
                    
                    // Create Predicate to get courses with the areaName
                    let predicate = NSPredicate(format: "%K == %@", CourseArea, areaname)
                    fetchRequest.predicate = predicate
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    // Execute Fetch Request
                    do {
                        let courses = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                        
                        for course in courses {
                            //assigning relation
                            course.setValue(area, forKey: "area")
                        }
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                }// end areaName
            }// end for
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func saveManagedContext(){
        
        do {
            try self.managedContext.save()
            print("DB Saved")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }// end catch
    }// end saveManagedContext
    
}







