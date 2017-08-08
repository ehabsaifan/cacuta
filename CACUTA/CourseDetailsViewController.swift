//
//  CourseDetailsViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/12/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

class CourseDetailsViewController: UIViewController {
    
    @IBOutlet weak var addButtonLabel: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var descritLabel: UITextView!
    @IBOutlet weak var areaLabel: UILabel!
    
    fileprivate var name: String?
    fileprivate var code: String?
    fileprivate var descript: String?
    fileprivate var college: String?
    fileprivate var units: String?
    fileprivate var area: String?
    fileprivate var subArea: String?
    fileprivate var depart: String?
    
    fileprivate var isFavorite: Bool? = false
    
    var course : NSManagedObject?
    
    fileprivate var favCourse : NSManagedObject?
    fileprivate var student: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.card.layer.cornerRadius = 15.0
        self.card.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = false
        
        self.fetch()
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetch()
    }
    
    @IBAction func addToFavorite(_ sender: AnyObject) {
        if DataManager.currentManager.isAuthenticated {
            if let student = User.currentUser.getStudentObject() {
                if let isFavorite = self.isFavorite, isFavorite == false, let name = self.name, let descript = self.descript, let depart = self.depart, let code = self.code, let units = self.units, let area = self.area, let subArea = self.subArea, let college = self.college {
                    
                    var info: [String: String] = [:]
                    info[ClassName] = name
                    info[ClassCode] = code
                    info[ClassDescript] = descript
                    info[ClassDepart] = depart
                    info[ClassUnits] = units
                    info[ClassArea] = area
                    info[ClassSubArea] = subArea
                    info[ClassCollege] = college
                    
                    DataManager.addFavoritCourseForUser(student, info: info, completion: { (success, error) in
                        if success {
                            self.done()
                        }else if let error = error {
                            ProgressHUD.displayMessage("Could not add course: \(error), \(error.userInfo)", fromView: self.view)
                        }
                    })
                }// end isfavorite
                else if let favCourse = self.favCourse {
                    // Removing favoriteCourse
                    let favCourses = student.mutableSetValue(forKey: "favoriteCourses")
                    favCourses.remove(favCourse)
                    self.done()
                }// end is favCourse
            }// end if student
        }// end is authenticated
        else{
            ProgressHUD.displayMessage("Login First", fromView: self.view)
            delay(1.2, closure: {
                DataManager.currentManager.login(self, completion: nil)
            })// end delay
        }// end if else
    }
    
    fileprivate func fetch() {
        
        if let course = self.course {
            if let name = course.value(forKey: CourseName) as? String, let descript = course.value(forKey: CourseDescript) as? String, let depart = course.value(forKey: CourseDepart) as? String, let code = course.value(forKey: CourseCode) as? String, let units = course.value(forKey: CourseUnits) as? String, let area = course.value(forKey: CourseArea) as? String, let subArea = course.value(forKey: CourseSubArea) as? String, let college = course.value(forKey: CourseCollege) as? String {
                
                self.name = name
                self.code = code
                self.descript = descript
                self.depart = depart
                self.units = units
                self.area = area
                self.subArea = subArea
                self.college = college
                
                self.nameLabel?.text = self.name
                self.descritLabel?.text = self.descript
                self.departmentLabel?.text = self.depart
                self.codeLabel?.text = self.code
                self.unitsLabel?.text = self.units
                self.areaLabel?.text = self.area
                
                
                if DataManager.currentManager.isAuthenticated {
                    if let student = User.currentUser.getStudentObject() {
                        self.student = student
                        
                        let favCourses = student.mutableSetValue(forKey: "favoriteCourses")
                        
                        if favCourses.count == 0 {
                            self.isFavorite = false
                            self.favCourse = nil
                            self.updateView()
                        }else{
                            var found = false
                            for favCourse in favCourses {
                                if let favName = (favCourse as AnyObject).value(forKey: ClassName) as? String, favName == name {
                                    found = true
                                    self.isFavorite = true
                                    self.favCourse = favCourse as? NSManagedObject
                                    self.updateView()
                                    return
                                }
                            }// end for
                            if !found {
                                self.isFavorite = false
                                self.favCourse = nil
                                self.updateView()
                            }
                        }
                    }// end if student
                }// end isAuthenticated
            }// end if let course
        }// end if let course
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateView() {
        if let isFavorite = self.isFavorite, isFavorite == true {
            self.addButtonLabel?.setTitle("Remove From Favorite", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.red
        }else {
            self.addButtonLabel.setTitle("Add To Favorite", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.orange
        }
    }
    
    fileprivate func done(){
        if let isFavorite = self.isFavorite, isFavorite == true {
            ProgressHUD.displayMessage("Course Removed", fromView: self.view)
        }else{
            ProgressHUD.displayMessage("Course Added", fromView: self.view)
        }
        delay(1.2, closure: {
            self.dismiss(animated: true, completion: nil)
        })
    }// end done
    
    
}



