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
    
    class var currentManager : DataSourceManager {
        struct Static {
            static let instance : DataSourceManager = DataSourceManager()
        }
        return Static.instance
    }
    
    fileprivate var managedContext: NSManagedObjectContext = {
        //1
        return (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    }()
    
    override init() {
        super.init()
        
        print("DataSourceManager Init")
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
            
            
            //2
            let courseEntity =  NSEntityDescription.entity(forEntityName: Entities.Course.rawValue, in:self.managedContext)
            
            for i in 0..<rowsCount {
                let course = NSManagedObject(entity: courseEntity!, insertInto: self.managedContext)
                
                //3
                // Get course college
                course.setValue(csv.rows[i][College], forKey: CourseCollege)
                // Get course area
                course.setValue(csv.rows[i][Area], forKey: CourseArea)
                // Get course sub-area
                course.setValue(csv.rows[i][SubArea], forKey: CourseSubArea)
                // Get course department
                course.setValue(csv.rows[i][Depart], forKey: CourseDepart)
                // Get course number
                course.setValue(csv.rows[i][CourseNum], forKey: CourseCode)
                
                // Get course title
                let course_title = csv.rows[i][Name]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                course.setValue(course_title, forKey: CourseName)
                
                // Get course description
                let course_description = csv.rows[i][Descript]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                course.setValue(course_description, forKey: CourseDescript)
                
                // Get course units
                course.setValue(csv.rows[i][Units], forKey: CourseUnits)
                
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
                let area_note = csv.rows[i][Note]?.replacingOccurrences(of:"❤️", with: ",", options: .literal, range: nil)
                area.setValue(area_note, forKey: AreaNote)
                
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







