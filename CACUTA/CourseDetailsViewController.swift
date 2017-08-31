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
    
    internal var name: String?
    internal var code: String?
    internal var descript: String?
    internal var college: String?
    internal var units: String?
    internal var area: String?
    internal var subArea: String?
    internal var depart: String?
    
    var context = {
        AppDelegate.viewContext
    }()
    
    private var isFavorite = false
    
    var course: Course?
    internal var favoriteCourse: FavoriteCourse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.updateViewsContent(for: self.course)
        if DataManager.currentManager.isAuthenticated {
            self.checkIfFavoriteCourse(name: self.course?.name ?? "")
        }
    }
    
    internal func setupView(){
        self.card.layer.cornerRadius = 15.0
        self.card.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = false
        self.addButtonLabel.makeCircularEdges()
    }
    
    internal func updateViewsContent(for course: Course?) {
        
        self.name = course?.name
        self.code = course?.code
        self.descript = course?.about
        self.depart = course?.department
        self.units = course?.numOfUnits
        self.area = course?.areaName
        self.subArea = course?.subArea
        self.college = course?.college
        
        self.nameLabel?.text = course?.name
        self.descritLabel?.text = course?.about
        self.departmentLabel?.text = course?.department
        self.codeLabel?.text = course?.code
        self.unitsLabel?.text = course?.numOfUnits
        self.areaLabel?.text = course?.areaName
    }
    
    private func checkIfFavoriteCourse(name: String) {
        if let student = User.currentUser.student {
            guard let favCourses = student.favoriteCourses else{
                self.updateButtonTitle(isFavorite: false)
                return
            }
            
            for favCourse in favCourses {
                let favCourse = (favCourse as! FavoriteCourse)
                if favCourse.name == name {
                    self.isFavorite = true
                    self.favoriteCourse = favCourse
                    self.updateButtonTitle(isFavorite: true)
                    return
                }
            }// end for
        }
    }// end if student

    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        self.analyzePress()
    }
    
    internal func analyzePress(){
        if let student = User.currentUser.student, DataManager.currentManager.isAuthenticated {
            if self.isFavorite, let favCourse = self.favoriteCourse  {
                self.context.delete(favCourse)
                self.updateButtonTitle(isFavorite: false)
            }else if let course = self.course {
                let favCourse = FavoriteCourse.createFavoriteCourse(from: course, context: self.context)
                student.addToFavoriteCourses(favCourse)
                self.updateButtonTitle(isFavorite: true)
            }
            self.save(context: self.context)
            self.done()
        }// end is authenticated
        else{
            _ = ProgressHUD.displayMessage("Login First", fromView: self.view)
            delay(1.2, closure: {
                DataManager.currentManager.login(self, completion: nil)
            })// end delay
        }// end if else
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismissCard()
    }
    
    internal func dismissCard() {
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func updateButtonTitle(isFavorite: Bool) {
        if isFavorite {
            self.addButtonLabel?.setTitle("Remove From Favorite", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.red
        }else {
            self.addButtonLabel.setTitle("Add To Favorite", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.orange
        }
    }
    
    fileprivate func done(){
        if isFavorite {
            _ = ProgressHUD.displayMessage("Course Removed", fromView: self.view)
        }else{
            _ = ProgressHUD.displayMessage("Course Added", fromView: self.view)
        }
        delay(1.2, closure: {
            self.dismiss(animated: true, completion: nil)
        })
    }// end done
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error.localizedDescription)")
        }// end catch
    }// end save
}



