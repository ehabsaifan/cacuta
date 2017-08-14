//
//  FavoriteCoursesTableViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/13/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD


let AddCoursesToFavoriteNotification = "AddCoursesToFavoriteNotification"

class FavoriteCoursesTableViewController: UITableViewController {
    
    fileprivate var hud: MBProgressHUD?
    
    private var coursesDict : [Area: [FavoriteCourse]] = [:]{
        didSet{
            if self.coursesDict.count == 0 {
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    
    private var areaKeys: [Area]{
        return self.coursesDict.keys.sorted(by: { (area1, area2) -> Bool in
            if let name1 = area1.name, let name2 = area2.name {
                return  name1 > name2
            }
            return false
        })
    }
    
    var context = {
        AppDelegate.viewContext
    }()
    
    fileprivate var cousreDeleted: NSManagedObject?
    //fileprivate var areaDict: [String: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.coursesDict = [:]
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ClassTakenNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.updateUI()
        }
        self.updateUI()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    private func updateUI(){
       
        guard let student = User.currentUser.student, DataManager.currentManager.isAuthenticated else{
            self.coursesDict = [:]
            return
        }
        
        //self.areaDict = Area.getDict(context: self.context)
        self.prepareDataDictionary(student: student)
    }
    
    private func prepareDataDictionary(student: Student){
        self.coursesDict = [:]
        self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
        if let favCourses = student.favoriteCourses {
            for course in favCourses {
                if let favCourse = course as? FavoriteCourse, let area = favCourse.area {
                    if var areaList = self.coursesDict[area] {
                        areaList.append(favCourse)
                    }else{
                        self.coursesDict[area] = [favCourse]
                    }
                }
            }// end for
        }
        self.hud?.hide(animated: true)
    }

    @IBAction func addCourses(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: AddCoursesToFavoriteNotification), object: self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.coursesDict.count > 1 {
            return self.areaKeys.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.areaKeys.count > 0 {
            if let courses = self.coursesDict[self.areaKeys[section]] {
                return courses.count
            }
            return 1
        }
        return 1
    }
    
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        if self.coursesDict.count == 0 {
    //            return ""
    //        }
    //        let keys = self.coursesDict.keys.sort()
    //
    //        return keys[section]
    //    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.areaKeys.count > 0 {
            
            let area = self.areaKeys[section]
            let areaNameString = NSMutableAttributedString(string: area.name ?? "")
            
            let atr = [NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 12)!]
            let rest = "    -->   \(area.minRequierdUnits ?? "") units required"
            let attrString = NSAttributedString(string: rest, attributes: atr)
            
            areaNameString.append(attrString)
            
            let view = UITableViewHeaderFooterView()
            view.textLabel?.attributedText = areaNameString
            view.textLabel?.textColor = UIColor.orange
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if self.coursesDict.keys.count > 0 {
            
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            
            let area = self.areaKeys[section]
            let areaNameString = NSMutableAttributedString(string: area.name ?? "")
            
            let atr = [NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 14)!]
            let rest = "    -->   \(area.minRequierdUnits ?? "") units required"
            let attrString = NSAttributedString(string: rest, attributes: atr)
            
            
            areaNameString.append(attrString)
            
            header.textLabel?.attributedText = areaNameString
            header.textLabel?.textColor = UIColor.orange
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.coursesDict.count == 0 {
            return self.tableView.dequeueReusableCell(withIdentifier: "NullCellIdentifier", for: indexPath)
        }
        
        let reuseIdentifier = "ClassCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCourseTableViewCell
        
        let areaName = self.areaKeys[indexPath.section]
        
        if let favCourses = self.coursesDict[areaName] {
            let course = favCourses[indexPath.row]
            if let name = course.name, let units = course.numOfUnits{
                cell.courseName?.text =   "\(name)"
                cell.courseUnitss?.text = "\(units) units"
            }
            if course.isTaken == true {
                cell.courseStatus?.text = IsCourseCompleted.Completed.rawValue
                cell.courseStatus?.textColor = UIColor.orange
            }else {
                cell.courseStatus?.text = IsCourseCompleted.NotCompleted.rawValue
                cell.courseStatus?.textColor = UIColor.purple
            }
            return cell
        }
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if self.coursesDict.count == 0 {
            return false
        }
        return true
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let area = self.areaKeys[indexPath.section]
            if let courses = self.coursesDict[area]{
                self.cousreDeleted = courses[indexPath.row]
                if self.deleteCourse(self.cousreDeleted) {
                    if self.coursesDict[area]?.count == 1 {
                        self.coursesDict[area] = nil
                    }else{
                        self.coursesDict[area]?.remove(at: indexPath.row)
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func deleteCourse(_ course: NSManagedObject?) -> Bool {
        if let course = course {
            course.managedObjectContext?.delete(course)
            do{
                try course.managedObjectContext?.save()
                return true
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                return false
            }// end catch
        }
        return false
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ClassDetailSegue" {
            
            if let CVC = segue.destination as? FavoriteClassDetailsViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    let area = self.areaKeys[indexPath.section]
                    
                    if let course = self.coursesDict[area]?[indexPath.row] {
                        CVC.favoriteCourse = course
                    }
                }// end if inedxPath
            }// end if CVC
        }
    }//end if segue
    
}
