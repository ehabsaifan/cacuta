//
//  User.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

class User: NSObject {
    
    private var context = {
        AppDelegate.viewContext
    }()
    
    var name : String?
    var college: String?
    var gpa: String?
    var id : String?
    var password: String?
    var profileImage : UIImage?
    var univChoice: String?
    var student: Student?
    var totalUnitsCompleted = "N/A"
    
    class var currentUser : User {
        struct Static {
            static let instance = User()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedInNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.save()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.id = nil
            self.save()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { [unowned self](notification) -> Void in
            self.save()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main, using: { (NSNotification) in
            if let prevID = UserDefaults.standard.object(forKey: "user_id") as? String {
                self.id = prevID
                DataManager.currentManager.isAuthenticated = true
                if let student = self.getStudentObject() {
                    self.fetchUserInfo(student)
                }
                _ = Area.getDict(context: self.context)
            }
        })
    }
    
    func updateUserInfo(name: String?, gpa: Double?, university: String?, image: UIImage?, completion: UpdateResponse) {
        if let id = User.currentUser.id {
            let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
            let predicate = NSPredicate(format: "%K == %@", StdID, id)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                if let student = try self.context.fetch(fetchRequest).first {
                    student.name = name
                    student.gpa = gpa ?? 0
                    student.image = image?.convertToNSData()
                    student.targetUniversity = university
                    self.save(context: self.context)
                    self.fetchUserInfo(student)
                    if let completion = completion {
                        completion(true, nil)
                    }
                }
            }catch let error as NSError{
                if let completion = completion {
                    completion(false, error)
                }
                print("Could not fetch student: \(error.localizedDescription)")
            }
            
        }// end if id
    }
    
    // CourseDetails method
    func getStudentObject() -> Student?{
        if let id = id {
            
            let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
            let predicate = NSPredicate(format: "%K == %@", StdID, id)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                return try self.context.fetch(fetchRequest).first
            }catch let error as NSError{
                print("Could not fetch Student: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    // SignIn Message
    func fetchUserInfo(_ student: Student){
        self.student = student
        self.name = student.name
        self.gpa = "\(student.gpa)"
        self.univChoice = student.targetUniversity
        self.college = student.college
        self.id = student.studentID
        self.password = student.password
        if let data = student.image as Data? {
            self.profileImage = UIImage(data: data)
        }
    }
    
    func getAreasCompletetionProgress() -> [String: Double]? {
        if let favCourses = self.student?.favoriteCourses {
            var areasCompletionProgress = [String: Double]()
            //Get number of units taken for each Area
            var areasUnitsTakenDict = [String: Double]()
            var sumOfUnitsTaken: Double = 0
            for course in favCourses {
                if let favCourse = course as? FavoriteCourse, let area = favCourse.areaName, let units =  favCourse.numOfUnits, let unitsCount =  Double(units), favCourse.isTaken == true{
                    if areasUnitsTakenDict[area] != nil {
                        areasUnitsTakenDict[area]! += unitsCount
                    }else{
                        areasUnitsTakenDict[area] = unitsCount
                    }
                    sumOfUnitsTaken += unitsCount
                }
            }// end for
            
            self.totalUnitsCompleted = "\(sumOfUnitsTaken)"
            let areasMinimumUnitsRequiredDict = Area.getDict(context: self.context)
            
            for (key, value) in areasUnitsTakenDict {
                let percentage = (value * 100.0)/Double(areasMinimumUnitsRequiredDict[key]!)
                areasCompletionProgress[key] = percentage
            }
            return areasCompletionProgress
        }
        return nil
    }
    
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error.localizedDescription)")
        }// end catch
    }// end save

    fileprivate func save() {
        UserDefaults.standard.set(self.id, forKey: "user_id")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func load(){
        self.id = UserDefaults.standard.object(forKey: "user_id") as? String
    }
    
}
