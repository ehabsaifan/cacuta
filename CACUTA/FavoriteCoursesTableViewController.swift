//
//  FavoriteCoursesTableViewController.swift
//  UTA//
//  Created by Ehab Saifan on 6/13/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let AddCoursesToFavoriteNotification = "AddCoursesToFavoriteNotification"

class FavoriteCoursesTableViewController: UITableViewController {
    
    fileprivate var hud: MBProgressHUD?
    
    fileprivate var coursesDict : [String: [NSManagedObject]] = [:]{
        didSet{
            if self.coursesDict.count == 0 {
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    
    fileprivate var cousreDeleted: NSManagedObject?
    fileprivate var areaDict: [String: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.coursesDict = [:]
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ClassTakenNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.update()
        }
        self.update()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    
    fileprivate func update(){
        
        self.areaDict = User.currentUser.fetchAreas()
        
        if DataBaseManager.currentManager.isAuthenticated{
            if let student = User.currentUser.student{
                self.coursesDict = [:]
                self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
                
                let favCourses = student.mutableSetValue(forKey: "favoriteCourses")
                for course in favCourses {
                    if let course = course as? NSManagedObject, let area = course.value(forKey: ClassArea) as? String {
                        if self.coursesDict[area]?.count > 0 {
                            self.coursesDict[area]?.append(course)
                        }else{
                            self.coursesDict[area] = [course]
                        }
                    }
                }// end for
            }
            self.hud?.hide(true)
            self.tableView.reloadData()
        }else {
            self.coursesDict = [:]
        }
    }// end update
    
    @IBAction func addCourses(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: AddCoursesToFavoriteNotification), object: self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.coursesDict.count > 1 {
            return self.coursesDict.keys.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.coursesDict.count > 0 {
            var keys = self.coursesDict.keys.sorted()
            if let courses = self.coursesDict[keys[section]] {
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
        if self.coursesDict.keys.count > 0 {
            let keys = self.coursesDict.keys.sorted()
            let areaName = keys[section]
            
            let area = NSMutableAttributedString(string: areaName)
            
            let atr = [NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 12)!]
            let rest = "    -->   \(self.areaDict![areaName]!) units required"
            let attrString = NSAttributedString(string: rest, attributes: atr)
            
            area.append(attrString)
            
            let view = UITableViewHeaderFooterView()
            view.textLabel?.attributedText = area
            view.textLabel?.textColor = UIColor.orange
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if self.coursesDict.keys.count > 0 {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            
            let keys = self.coursesDict.keys.sorted()
            let areaName = keys[section]
            
            let area = NSMutableAttributedString(string: areaName)
            
            let atr = [NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 14)!]
            let rest = "    -->   \(self.areaDict![areaName]!) units required"
            let attrString = NSAttributedString(string: rest, attributes: atr)
            
            
            area.append(attrString)
            
            header.textLabel?.attributedText = area
            header.textLabel?.textColor = UIColor.orange
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.coursesDict.count == 0 {
            return self.tableView.dequeueReusableCell(withIdentifier: "NullCellIdentifier", for: indexPath)
        }
        
        let reuseIdentifier = "ClassCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCourseTableViewCell
        
        let keys = self.coursesDict.keys.sorted()
        let areaName = keys[indexPath.section]
        
        if let favCourses = self.coursesDict[areaName] {
            let course = favCourses[indexPath.row]
            if let name = course.value(forKey: ClassName) as? String, let id = course.value(forKey: ClassCode) as? String, let units = course.value(forKey: ClassUnits) as? String{
                cell.courseName?.text = "\(name)   \(id)"
                cell.courseUnitss?.text = "\(units) units"
            }
            if let isTaken = course.value(forKey: ClassIsTaken) as? Bool, isTaken == true{
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
            let keys = self.coursesDict.keys.sorted()
            let area = keys[indexPath.section]
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
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ClassDetailSegue" {
            
            if let CVC = segue.destination as? FavoriteClassDetailsViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    let keys = self.coursesDict.keys.sorted()
                    let area = keys[indexPath.section]
                    
                    if let course = self.coursesDict[area]?[indexPath.row] {
                        CVC.course = course
                    }
                }// end if inedxPath
            }// end if CVC
        }
    }//end if segue
    
}
