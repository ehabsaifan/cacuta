//
//  ProfileViewController.swift
//  UTA//
//  Created by Ehab Saifan on 6/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profle_name: UILabel!
    @IBOutlet weak var current_gpa: UILabel!
    @IBOutlet weak var total_units: UILabel!
    @IBOutlet weak var current_college: UILabel!
    @IBOutlet weak var university_goal: UIImageView!
    @IBOutlet weak var uniChoice: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    
    @IBOutlet weak var area1Label: UILabel!
    @IBOutlet weak var area2Label: UILabel!
    @IBOutlet weak var area3Label: UILabel!
    @IBOutlet weak var area4Label: UILabel!
    @IBOutlet weak var area5Label: UILabel!
    @IBOutlet weak var area6Label: UILabel!
    
    fileprivate var areaDict: [String:Int]? = [:]
    fileprivate var courseDict: [String: Int]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profile_image.makeCircular()
        self.fetchStdInfo()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.profle_name?.text = "Student"
            self.current_gpa?.text = "N/A"
            self.uniChoice?.text = "TBD"
            self.profile_image?.image = UIImage(named: "user")
            self.total_units?.text = "\(0)"
            self.current_college?.text = "Unkown"
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchStdInfo()
        
    }
    
    fileprivate func fetchStdInfo() {
        if DataBaseManager.currentManager.isAuthenticated {
            if let name = User.currentUser.name{
                self.profle_name?.text = name
            }
            
            if let gpa = User.currentUser.gpa{
                self.current_gpa?.text = "\(gpa)"
            }
            
            if let choice = User.currentUser.univChoice, let image = UIImage(named: choice){
                self.university_goal?.image = image
                self.uniChoice?.text = choice
            }
            
            if let image = User.currentUser.profileImage {
                self.profile_image?.image = image
            }
            if let college = User.currentUser.college {
                self.current_college.text = college
            }
            
            self.updateAreas()
            
        }else {
            self.profle_name?.text = "Student"
            self.current_gpa?.text = "\(0)"
            self.uniChoice?.text = "TBD"
            self.profile_image?.image = UIImage(named: "user")
            self.total_units?.text = "\(0)"
            self.current_college?.text = "Unkown"
        }
    }
    
    fileprivate func updateAreas() {
        self.areaDict = User.currentUser.areaDict
        if let student = User.currentUser.student {
            let favCourses = student.mutableSetValue(forKey: "favoriteCourses")
            self.courseDict = [:]
            for course in favCourses {
                
                if let course = course as? NSManagedObject, let area = course.value(forKey: ClassArea) as? String, let units = course.value(forKey: ClassUnits) as? String, let unit = Int(units), let isTaken = (course.value(forKey: ClassIsTaken) as? Bool), isTaken == true{
                    
                    if self.courseDict?[area] != nil {
                        self.courseDict?[area]! += unit
                    }else{
                        self.courseDict?[area] = unit
                    }
                }
            }// end for
            
            var total = 0
            for key in self.courseDict!.keys {
                total += self.courseDict![key]!
            }
            self.total_units.text = "\(total)"
            
        }// end if let student
        
        if let keys = self.courseDict?.keys {
            
            for key in keys{
                
                if self.courseDict?[key] >= self.areaDict?[key] {
                    switch key {
                    case "Area 1":
                        self.area1Label.backgroundColor = UIColor.orange
                    case "Area 2":
                        self.area2Label.backgroundColor = UIColor.orange
                    case "Area 3":
                        self.area3Label.backgroundColor = UIColor.orange
                    case "Area 4":
                        self.area4Label.backgroundColor = UIColor.orange
                    case "Area 5":
                        self.area5Label.backgroundColor = UIColor.orange
                    case "Area 6":
                        self.area6Label.backgroundColor = UIColor.orange
                    default:
                        Void()
                    }// end switch
                }else{
                    switch key {
                    case "Area 1":
                        self.area1Label.backgroundColor = UIColor.lightGray
                    case "Area 2":
                        self.area2Label.backgroundColor = UIColor.lightGray
                    case "Area 3":
                        self.area3Label.backgroundColor = UIColor.lightGray
                    case "Area 4":
                        self.area4Label.backgroundColor = UIColor.lightGray
                    case "Area 5":
                        self.area5Label.backgroundColor = UIColor.lightGray
                    case "Area 6":
                        self.area6Label.backgroundColor = UIColor.lightGray
                    default:
                        Void()
                    }// end switch
                }
            }// end for
        }// if let keys
    }
    
    @IBAction func editProfilePressed(_ sender: UIBarButtonItem) {
        if DataBaseManager.currentManager.isAuthenticated {
            self.performSegue(withIdentifier: "EditProfileSegue", sender: self)
        }else{
            ProgressHUD.displayMessage("Please login first", fromView: self.view)
            delay(0.5) {
                self.dismiss(animated: true, completion: nil)
            }

        }
    }
       
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
