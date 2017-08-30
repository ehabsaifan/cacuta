//
//  FavoriteClassDetailsViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/23/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

let ClassTakenNotification = "ClassTakenNotification"

class FavoriteClassDetailsViewController: CourseDetailsViewController {
    
    private var isTaken = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.updateViewsContent(for: self.favoriteCourse)
        if DataManager.currentManager.isAuthenticated {
            self.checkIfFavoriteCourseIsTaken()
        }
    }
    
    override func analyzePress(){
        let isTaken = self.favoriteCourse?.isTaken ?? false
        self.favoriteCourse?.isTaken = !isTaken
        self.updateButton(isTaken: !isTaken)
        self.done()
        self.isTaken = !isTaken
        self.save(context: self.context)
        NotificationCenter.default.post(name: Notification.Name(rawValue: ClassTakenNotification), object: nil)
    }
    
    private func checkIfFavoriteCourseIsTaken() {
        self.isTaken = self.favoriteCourse?.isTaken ?? false
        self.updateButton(isTaken: isTaken)
    }

    fileprivate func updateButton(isTaken: Bool) {
        if isTaken {
            self.addButtonLabel?.setTitle("Remove from courses completed", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.red
        }else {
            self.addButtonLabel?.setTitle("Add to courses completed", for: UIControlState())
            self.addButtonLabel?.backgroundColor = UIColor.orange
        }
    }
    
    fileprivate func done(){
        if let isTaken = self.favoriteCourse?.isTaken, isTaken == true {
            _ = ProgressHUD.displayMessage("Class Added", fromView: self.view)
        }else{
            _ = ProgressHUD.displayMessage("Class Removed", fromView: self.view)
        }
        delay(1.2, closure: {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
    }// end done
    
    
}



