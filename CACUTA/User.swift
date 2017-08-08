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
    var student: NSManagedObject?
    var areaDict: [String:Int]? = [:]
    
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
                _ = self.getStudentObject()
                self.fetchUserInfo(self.student!)
                _ = self.fetchAreas()
            }
        })
    }
    
    func updateUserInfo(_ info: [String:String], completion: UpdateResponse) {
        if let id = User.currentUser.id {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.Student.rawValue)
            let predicate = NSPredicate(format: "%K == %@", StdID, id)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            
            DataManager.fetchRequest(fetchRequest) { (result, error) in
                if let result = result, result.count == 1 {
                    DataManager.updateValueForObject(result[0], info: info, completion: { (success, error) in
                        if success {
                            User.currentUser.fetchUserInfo(result[0])
                            
                            if let completion = completion {
                                completion(true, nil)
                            }
                            
                        }// end if success
                        else if let error = error{
                            if let completion = completion {
                                completion(false, error)
                            }
                            print("Could not update student: \(error), \(error.userInfo)")
                        }
                    })
                }// end if result
                if let error = error {
                    if let completion = completion {
                        completion(false, error)
                    }
                    print("Could not fetch student: \(error), \(error.userInfo)")
                }// end if let error
            }
        }// end if id
    }
    
    // CourseDetails method
    func getStudentObject() -> NSManagedObject?{
        if let id = id {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.Student.rawValue)
            let predicate = NSPredicate(format: "%K == %@", StdID, id)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            
            DataManager.fetchRequest(fetchRequest, completion: { (result, error) in
                if let result = result{
                    self.student =  result.first
                }
            })
        }
        return self.student
    }
    
    // SignIn Message
    func fetchUserInfo(_ user: NSManagedObject){
        self.student = user
        if let name = user.value(forKey: StdName) as? String{
            self.name = name
        }
        if let gpa = user.value(forKey: StdGPA) as? Double{
            self.gpa = "\(gpa)"
        }
        if let choice = user.value(forKey: StdUnivChoive) as? String {
            self.univChoice = choice
        }
        if let picData = user.value(forKey: StdProfileImage) as? Data, let image = UIImage(data: picData){
            self.profileImage = image
        }
        if let college = user.value(forKey: StdCollege) as? String{
            self.college = college
        }
        if let id = user.value(forKey: StdID) as? String{
            self.id = id
        }
        if let password = user.value(forKey: StdPassword) as? String{
            self.password = password
        }
    }
    
    func fetchAreas() -> [String: Int]?{
        
        self.areaDict = [:]
        
        let fetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: AreaName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let areas = try context.fetch(fetchRequest)
            for area in areas {
                if let name = area.name, let minUnits = area.minRequierdUnits, let units = Int(minUnits){
                    self.areaDict?[name] = units
                }
            }
        }catch let error as NSError{
            print("Could not fetch Areas: \(error.localizedDescription)")
        }
        return self.areaDict
    }

    fileprivate func save() {
        UserDefaults.standard.set(self.id, forKey: "user_id")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func load(){
        self.id = UserDefaults.standard.object(forKey: "user_id") as? String
    }
    
    // SignUP Message
    func setUserInfo(_ info: [String:String]) {
        self.name = info[StdName]
        self.gpa = info[StdGPA]
        self.password = info[StdPassword]
        self.id = info[StdID]
        self.college = info[StdCollege]
        self.univChoice = info[StdUnivChoive]
    }
}
