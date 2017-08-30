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
    
    fileprivate func save() {
        UserDefaults.standard.set(self.id, forKey: "user_id")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func load(){
        self.id = UserDefaults.standard.object(forKey: "user_id") as? String
    }
    
}
