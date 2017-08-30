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
        if let logInController = controller.storyboard?.instantiateViewController(withIdentifier: "SignInController") as? SignInViewController{
            
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
    
    class func initUser(_ info: [String:AnyObject], completion: UpdateResponse){

        let student = Student(context: self.currentManager.managedContext)
        student.name = info[StdName] as? String
        student.gpa = info[StdGPA] as? Double ?? 0
        student.password = info[StdPassword] as? String
        student.studentID = info[StdID] as? String
        student.college = info[StdCollege] as? String
        student.targetUniversity = info[StdUnivChoive] as? String
    
        self.currentManager.saveManagedContext { (success, error) in
            if success {
                DataManager.currentManager.isAuthenticated = true
                User.currentUser.fetchUserInfo(student)
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
    
    class func isStudentExist(_ id: String) -> (success: Bool, error: NSError?) {
        
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", StdID, id)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let sucess = try self.currentManager.managedContext.fetch(fetchRequest).count > 0
            return (success: sucess, error: nil)
        }catch let error as NSError {
            return (success: false, error: error)
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
}




