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
    
    private var hud: MBProgressHUD?
    
    private var favoriteCourses : [String: [FavoriteCourse]] = [:]{
        didSet{
            if self.favoriteCourses.count == 0 {
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    
    var context = {
        AppDelegate.viewContext
    }()
    
    fileprivate var areaDict: [String: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.favoriteCourses = [:]
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
            self.favoriteCourses = [:]
            return
        }
        
        self.areaDict = Area.getDict(context: self.context)
        self.prepareDataDictionary(student: student)
    }
    
    private func prepareDataDictionary(student: Student){
        self.favoriteCourses = [:]
        self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
        
        let sortDescriptor1 = NSSortDescriptor(key: CourseArea, ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: CourseSubArea, ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: CourseName, ascending: true)
        
        if let favCourses =  student.favoriteCourses?.sortedArray(using: [sortDescriptor1, sortDescriptor2, sortDescriptor3]) {
            for course in favCourses {
                if let favCourse = course as? FavoriteCourse, let areaName = favCourse.areaName{
                    
                    if self.favoriteCourses[areaName] != nil {
                        self.favoriteCourses[areaName]?.append(favCourse)
                    }else{
                        self.favoriteCourses[areaName] = [favCourse]
                    }
                }
            }// end for
        }
        self.hud?.hide(animated: true)
    }
    
    @IBAction func addCourses(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: AddCoursesToFavoriteNotification), object: self)
    }
    
    private func getHeaderTitle(section: Int) -> NSAttributedString {
        
        let key = self.favoriteCourses.keys.sorted()[section]
        
        var atr = [NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 14)!]
        let areaNameString = NSMutableAttributedString(string: "   \(key)", attributes: atr)
        
        atr = [NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 12)!]
        let rest = "    -->   \(self.areaDict?[key] ?? 0) units required"
        let attrString = NSAttributedString(string: rest, attributes: atr)
        
        areaNameString.append(attrString)
        return areaNameString
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.favoriteCourses.keys.count > 1 ? self.favoriteCourses.keys.count : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard self.favoriteCourses.keys.count != 0 else {
            return 1
        }
        
        let key = self.favoriteCourses.keys.sorted()[section]
        if let count = self.favoriteCourses[key]?.count, count > 0 {
            return count
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.favoriteCourses.keys.count > 0 else {
            return nil
        }
        let text = "\(self.getHeaderTitle(section: section))"
        return text
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UILabel()
        view.attributedText = self.getHeaderTitle(section: section)
        view.textColor = UIColor.orange
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.favoriteCourses.count == 0 {
            return self.tableView.dequeueReusableCell(withIdentifier: "NullCellIdentifier", for: indexPath)
        }
        
        let reuseIdentifier = "ClassCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCourseTableViewCell
        
        let key = self.favoriteCourses.keys.sorted()[indexPath.section]
        
        if let favCourses = self.favoriteCourses[key] {
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
        if self.favoriteCourses.count == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteCourse(indexPath: indexPath)
        }
    }
    
    private func deleteCourse(indexPath: IndexPath) {
        // Delete the row from the data source
        let key = self.favoriteCourses.keys.sorted()[indexPath.section]
        if let cousreToBeDeleted = self.favoriteCourses[key]?[indexPath.row] {
            if self.successfullyDeleted(cousreToBeDeleted) {
                self.favoriteCourses[key]?.remove(at: indexPath.row)
                if self.favoriteCourses[key]?.count == 0 {
                    self.favoriteCourses[key] = nil
                }
                tableView.reloadData()
            }
        }
    }

    private func successfullyDeleted(_ course: FavoriteCourse) -> Bool {
        self.context.delete(course)
        do {
            try self.save(context: self.context)
            return true
        }catch{
            return false
        }
    }
    
    private func save(context: NSManagedObjectContext) throws{
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error.localizedDescription)")
            throw error
        }// end catch
    }// end save
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ClassDetailSegue" {
            
            if let CVC = segue.destination as? FavoriteClassDetailsViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    let key = self.favoriteCourses.keys.sorted()[indexPath.section]
                    
                    if let course = self.favoriteCourses[key]?[indexPath.row] {
                        CVC.favoriteCourse = course
                    }
                }// end if inedxPath
            }// end if CVC
        }
    }//end if segue
    
}
