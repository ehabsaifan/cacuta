//
//  DataManager.swift
//  CACUTA
//  Created by Ehab Saifan on 6/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

typealias FetchResponse = ((_ result: [NSManagedObject]?, _ error : NSError?) -> ())?
typealias UpdateResponse = ((_ success : Bool, _ error : NSError?) -> ())?

let UserLoggedInNotification = "UserLoggedInNotification"
let UserLoggedOutNotification = "UserLoggedOutNotification"

class DataManager: NSObject {
    
    fileprivate var updateCompletion: UpdateResponse?
    fileprivate var fetchCompletion: FetchResponse
    
    var isAuthenticated = false {
        didSet{
            if self.isAuthenticated == true {
                NotificationCenter.default.post(name: Notification.Name(rawValue: UserLoggedInNotification), object: nil)
                print("User Logged In")
            }else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: UserLoggedOutNotification), object: nil)
                print("User Logged Out")
            }
        }
    }
    
    fileprivate var managedContext: NSManagedObjectContext = {
        return AppDelegate.viewContext
    }()
    
    static let currentManager = DataManager()
    
    override init(){
        super.init()
    }
    
    func login(_ controller : UIViewController, completion : UpdateResponse = nil){
        if let logInController = controller.storyboard?.instantiateViewController(withIdentifier: "SignInController") as?SignInViewController{
            
            controller.present(logInController, animated:true, completion: nil)
            if let completion = completion {
                completion(true, nil)
            }
        }
    }
}

extension DataManager {
    class func fetchedResultController(_ entity: Entities, predicate: NSPredicate? = nil, descriptor: [NSSortDescriptor]? = nil) -> NSFetchedResultsController<NSFetchRequestResult>? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = descriptor
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.currentManager.managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    class func addFavoritCourseForUser(_ student: NSManagedObject, info: [String: String], completion: UpdateResponse){
        if let entityObj = NSEntityDescription.entity(forEntityName: Entities.FavoriteCourse.rawValue, in: self.currentManager.managedContext) {
            let favoritCourse = NSManagedObject(entity: entityObj, insertInto: self.currentManager.managedContext)
            for key in info.keys {
                favoritCourse.setValue(info[key], forKey: key)
            }
            let favCourses = student.mutableSetValue(forKey: "favoriteCourses")
            favCourses.add(favoritCourse)
            self.currentManager.saveObject(student, completion: { (success, error) in
                if success {
                    if let completion = completion{
                        completion(true, nil)
                    }
                }else{
                    if let completion = completion{
                        completion(false, error)
                    }
                }// end else
            })
        }// end entity
    }
    
    //updating a record
    class func updateValueForObject(_ obj: NSManagedObject, info: [String: String], completion: UpdateResponse){
        for key in info.keys {
            if key == StdGPA {
                obj.setValue(Double(info[key]!), forKey: key)
                continue
            }
            if key == StdProfileImage {
                if let data = Data(base64Encoded: info[key]!, options: .ignoreUnknownCharacters){
                    obj.setValue(data, forKey: key)
                    continue
                }
            }
            if key == ClassIsTaken {
                obj.setValue(info[key]?.toBool(), forKey: key)
                continue
            }
            else{
                obj.setValue(info[key], forKey: key)
            }
            
        }
        self.currentManager.saveManagedContext({ (success, error) in
            if success {
                if let completion = completion{
                    completion(true, nil)
                }
            }else{
                if let completion = completion{
                    completion(false, error)
                }
            }// end else
        })
    }// end
    
    class func initUser(_ info: [String:String], completion: UpdateResponse){
        let studentEntity =  NSEntityDescription.entity(forEntityName: Entities.Student.rawValue, in:self.currentManager.managedContext)
        
        let student = NSManagedObject(entity: studentEntity!, insertInto: self.currentManager.managedContext)
        
        for key in info.keys {
            if key == StdGPA {
                student.setValue(Double(info[key]!), forKey: key)
                continue
            }
            if key == StdProfileImage {
                if let data = Data(base64Encoded: info[key]!, options: .ignoreUnknownCharacters){
                    student.setValue(data, forKey: key)
                    continue
                }
            }
            else{
                student.setValue(info[key], forKey: key)
            }
        }
        
        self.currentManager.saveManagedContext { (success, error) in
            if success {
                if let completion = completion{
                    completion(true, nil)
                }
            }else{
                if let completion = completion{
                    completion(false, error)
                }
            }// end else
        }
    }
    
    fileprivate func saveManagedContext(_ completion: UpdateResponse){
        do {
            try self.managedContext.save()
            if let completion = completion {
                completion(true, nil)
                print("DB Saved")
            }
        } catch let error as NSError  {
            if let completion = completion {
                completion(false, error)
                print("Could not save \(error), \(error.userInfo)")
            }
        }// end catch
    }// end saveManagedContext
    
    fileprivate func saveObject(_ object: NSManagedObject, completion: UpdateResponse) {
        do {
            try object.managedObjectContext?.save()
            if let completion = completion {
                completion(true, nil)
                print("DB Saved")
            }
        } catch let error as NSError  {
            if let completion = completion {
                completion(false, error)
                print("Could not save \(error), \(error.userInfo)")
            }
        }// end catch
    }
    
}




