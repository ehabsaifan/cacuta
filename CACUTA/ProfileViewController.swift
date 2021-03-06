//
//  ProfileViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profle_name: UILabel!
    @IBOutlet weak var current_gpa: UILabel!
    @IBOutlet weak var total_units: UILabel!
    @IBOutlet weak var current_college: UILabel!
    @IBOutlet weak var university_goal: UIImageView!
    @IBOutlet weak var uniChoice: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    
    @IBOutlet weak var area1Label: UIButton!
    @IBOutlet weak var area2Label: UIButton!
    @IBOutlet weak var area3Label: UIButton!
    @IBOutlet weak var area4Label: UIButton!
    @IBOutlet weak var area5Label: UIButton!
    @IBOutlet weak var area6Label: UIButton!
    
    fileprivate var areaDict: [String:Int]? = [:]
    fileprivate var courseDict: [String: Int]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.resetViews()
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetViews()
        self.fetchStdInfo()
    }
    
    fileprivate func fetchStdInfo() {
        if DataManager.currentManager.isAuthenticated {
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
        }
    }
    
    private func setupViews(){
        self.area1Label.makeCircularEdges()
        self.area2Label.makeCircularEdges()
        self.area3Label.makeCircularEdges()
        self.area4Label.makeCircularEdges()
        self.area5Label.makeCircularEdges()
        self.area6Label.makeCircularEdges()
        
        self.area1Label.titleLabel?.textAlignment = .center
        self.area2Label.titleLabel?.textAlignment = .center
        self.area3Label.titleLabel?.textAlignment = .center
        self.area4Label.titleLabel?.textAlignment = .center
        self.area5Label.titleLabel?.textAlignment = .center
        self.area6Label.titleLabel?.textAlignment = .center
        
        self.university_goal.makeCircularEdges()
        self.profile_image.makeCircular()
    }
    
    private func resetViews(){
        
        self.profle_name?.text = "Student"
        self.current_gpa?.text = "\(0)"
        self.uniChoice?.text = "TBD"
        self.profile_image?.image = UIImage(named: "user")
        self.total_units?.text = "\(0)"
        self.current_college?.text = "Unkown"
        
        self.resetAreasCompletionProgress()
    }
    
    private func resetAreasCompletionProgress(){
        let color = UIColor.lightGray
        self.area1Label.backgroundColor = color
        self.area1Label.setTitle("Area 1\n0%", for: .normal)
        self.area2Label.backgroundColor = color
        self.area2Label.setTitle("Area 2\n0%", for: .normal)
        self.area3Label.backgroundColor = color
        self.area3Label.setTitle("Area 3\n0%", for: .normal)
        self.area4Label.backgroundColor = color
        self.area4Label.setTitle("Area 4\n0%", for: .normal)
        self.area5Label.backgroundColor = color
        self.area5Label.setTitle("Area 5\n0%", for: .normal)
        self.area6Label.backgroundColor = color
        self.area6Label.setTitle("Area 6\n0%", for: .normal)
    }
    
    fileprivate func updateAreas() {
        if let areasProgress = User.currentUser.getAreasCompletetionProgress() {
            
            self.total_units.text = "\(User.currentUser.totalUnitsCompleted)"
            
            for (key, value) in areasProgress {
                let color: UIColor = (value >= 100 ? .orange: .lightGray)
                let text = "\(key)\n\(Int(value))%"
                let percentage = NSNumber(floatLiteral: value/100)
                switch key {
                case "Area 1":
//                    self.area1Label.backgroundColor = color
                    self.area1Label.setTitle(text, for: .normal)
                    self.area1Label.fillPercentage(percentage: percentage)
                case "Area 2":
//                    self.area2Label.backgroundColor = color
                    self.area2Label.setTitle(text, for: .normal)
                    self.area2Label.fillPercentage(percentage: percentage)
                case "Area 3":
//                    self.area3Label.backgroundColor = color
                    self.area3Label.setTitle(text, for: .normal)
                    self.area3Label.fillPercentage(percentage: percentage)
                case "Area 4":
//                    self.area4Label.backgroundColor = color
                    self.area4Label.setTitle(text, for: .normal)
                    self.area4Label.fillPercentage(percentage: percentage)
                case "Area 5":
//                    self.area5Label.backgroundColor = color
                    self.area5Label.setTitle(text, for: .normal)
                    self.area5Label.fillPercentage(percentage: percentage)
                case "Area 6":
//                    self.area6Label.backgroundColor = color
                    self.area6Label.setTitle(text, for: .normal)
                    self.area6Label.fillPercentage(percentage: percentage)
                default:
                    Void()
                }// end switch
            }// end for
        }// if let keys
    }
    
    @IBAction func editProfilePressed(_ sender: UIBarButtonItem) {
        if DataManager.currentManager.isAuthenticated {
            self.performSegue(withIdentifier: "EditProfileSegue", sender: self)
        }else{
            _ = ProgressHUD.displayMessage("Please login first", fromView: self.view)
            delay(0.5) {
                self.dismiss(animated: true, completion: nil)
            }

        }
    }
}
