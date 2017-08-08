//
//  FavoriteClassDetailsViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/23/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

let ClassTakenNotification = "ClassTakenNotification"

class FavoriteClassDetailsViewController: UIViewController {
    
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
    
    fileprivate var isTaken: Bool? = false
    
    var course : NSManagedObject?
    
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
    
    @IBAction func classTakenButton(_ sender: AnyObject) {
        if let isTaken = self.isTaken, let course = course{
            
            
            var info: [String: String] = [:]
            info[ClassIsTaken] = "\(!isTaken)"
            
            DataManager.updateValueForObject(course, info: info, completion: { [weak self] (success, error) in
                if success {
                    self?.fetch()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ClassTakenNotification), object: nil)
                    self?.done()
                }else{
                    if let error = error{
                        _ = ProgressHUD.displayMessage("Could update class info: \(error), \(error.userInfo)", fromView: self?.view)
                    }
                }
                })
        }
    }
    
    fileprivate func fetch() {
        
        if let course = self.course {
            if let name = course.value(forKey: ClassName) as? String, let descript = course.value(forKey: ClassDescript) as? String, let depart = course.value(forKey: ClassDepart) as? String, let code = course.value(forKey: ClassCode) as? String, let units = course.value(forKey: ClassUnits) as? String, let area = course.value(forKey: ClassArea) as? String, let subArea = course.value(forKey: ClassSubArea) as? String, let college = course.value(forKey: ClassCollege) as? String, let isTaken = course.value(forKey: ClassIsTaken) as? Bool {
                
                self.name = name
                self.code = code
                self.descript = descript
                self.depart = depart
                self.units = units
                self.area = area
                self.subArea = subArea
                self.college = college
                self.isTaken = isTaken
                
                self.nameLabel?.text = self.name
                self.descritLabel?.text = self.descript
                self.departmentLabel?.text = self.depart
                self.codeLabel?.text = self.code
                self.unitsLabel?.text = self.units
                self.areaLabel?.text = self.area
                
                self.updateView()
                
            }// end if let course
        }// end if let course
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateView() {
        if let isTaken = self.isTaken, isTaken == true {
            self.addButtonLabel?.setTitle("Class Taken", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.orange
        }else {
            self.addButtonLabel.setTitle("Class Not Taken Yet", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.red
        }
    }
    
    fileprivate func done(){
        if let isTaken = self.isTaken, isTaken == true {
            _ = ProgressHUD.displayMessage("Class Taken", fromView: self.view)
        }else{
            _ = ProgressHUD.displayMessage("Class Not Taken", fromView: self.view)
        }
        delay(1.2, closure: {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
    }// end done
    
    
}



