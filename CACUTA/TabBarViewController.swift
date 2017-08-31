//
//  TabBarViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/20/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit

let IsOnboardingDisplayed = "isOnboardingDisplayed"

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setNeedsStatusBarAppearanceUpdate()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AddCoursesToFavoriteNotification), object: nil, queue: OperationQueue.main) {[unowned self] (notification) -> Void in
            self.displayCourses()
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.standard.bool(forKey: IsOnboardingDisplayed){
            UserDefaults.standard.set(true, forKey: IsOnboardingDisplayed)
            self.performSegue(withIdentifier: "SimpleOnboardingSegue", sender: nil)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func displayCourses() {
        self.selectedIndex = 0
        if let navController = self.selectedViewController as? UINavigationController, let controller = navController.topViewController as? SearchViewController{
            
            controller.displayCourses(self)
        }
    }
    
}
