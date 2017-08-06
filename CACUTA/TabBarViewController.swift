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
        
        if DataBaseManager.currentManager.isAuthenticated{
           
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func displayCourses() {
        self.selectedIndex = 0
        if let navController = self.selectedViewController as? UINavigationController, let controller = navController.topViewController as? SearchViewController{
            
            controller.displayCourses(self)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }*/
}
