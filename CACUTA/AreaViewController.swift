//
//  AreaViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/11/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit
import CoreData
import MBProgressHUD

class AreaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    fileprivate var hud: MBProgressHUD?
    fileprivate var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    fileprivate var resultSearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchBarViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var areaNotesTextView: UITextView!
    
    private var context = {
        return AppDelegate.viewContext
    }()
    
    var area: NSManagedObject? {
        didSet{
            if area != nil {
                self.update()
            }
        }
    }
    
    fileprivate var areaName: String? = ""
    
    fileprivate var coursesDict : [String: [NSManagedObject]] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.update()
        self.initResultSearchController()
        self.fetchCourses()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateView()
    }
    
    fileprivate func update(){
        
        self.areaNotesTextView?.text = area?.value(forKey: AreaNote) as? String
        self.areaName = area?.value(forKey: AreaName) as? String
        
        self.navigationItem.title = self.areaName
        self.fetchCourses()
        
    }// end update
    
    fileprivate func fetchCourses(){
        
        let count = self.area?.value(forKey: AreaSecCount) as? Int
        if let name = self.areaName, let count = count {
            
            let sortDescriptor = NSSortDescriptor(key: CourseName, ascending: true)
            let predicate = NSPredicate(format: "%K == %@", CourseArea, name)
            
            self.fetchedResultsController = DataManager.fetchedResultController(Entities.Course, predicate: predicate, descriptor: [sortDescriptor])
            
            self.fetch(self.fetchedResultsController)
            
            let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
            
            for section in 0..<count {
                // Create Predicate
                let predicate = NSPredicate(format: "%K == %@ AND %K == %@", CourseSubArea, SectionsList[section], CourseArea, name)
                let sortDescriptor1 = NSSortDescriptor(key: CourseName, ascending: true)
                
                fetchRequest.sortDescriptors = [sortDescriptor1]
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    self.coursesDict[SectionsList[section]] = try self.context.fetch(fetchRequest)
                    self.hud?.hide(animated: true)
                }catch let error as NSError{
                    _ = ProgressHUD.displayMessage("Could not fetch Area: \(error.localizedDescription)", fromView: self.view)
                }
            }// end for
            self.hud?.hide(animated: true)
        }// end if let name
    }
    
    fileprivate func updateView(){
        
        self.areaNotesTextView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.areaNotesTextView?.textContainerInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 44
        
    }
    
    fileprivate func initResultSearchController(){
        // initialize search controller after the core data
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.hidesNavigationBarDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.delegate = self
        
        // places the built-in searchbar into the header of the table
        self.searchBarViewContainer.addSubview(self.resultSearchController.searchBar)
        
        // makes the searchbar stay in the current screen and not spill into the next screen
        definesPresentationContext = true
    }
    
    // update the contents of a fetch results controller
    fileprivate func fetch(_ frcToFetch: NSFetchedResultsController<NSFetchRequestResult>?) {
        if let frc = frcToFetch{
            do {
                try frc.performFetch()
            } catch {
                return
            }
        }// end if let
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableViewConstraints.constant = 136
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableViewConstraints.constant = 12
    }
    
    // updates the table view with the search results as user is typing...
    func updateSearchResults(for searchController: UISearchController) {
        // process the search string, remove leading and trailing spaces
        let searchText = searchController.searchBar.text!
        let trimmedSearchString = searchText.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // if search string is not blank
        if !trimmedSearchString.isEmpty {
            
            if let name = self.areaName{
                // form the search format
                let predicate = NSPredicate(format: "%K CONTAINS[c] %@ AND %K == %@", CourseName, trimmedSearchString, CourseArea, name)
                
                
                // add the search filter
                self.fetchedResultsController?.fetchRequest.predicate = predicate
            }
        }
        else {
            
            let sortDescriptor = NSSortDescriptor(key: CourseName, ascending: true)
            
            self.fetchedResultsController = DataManager.fetchedResultController(Entities.Course, predicate: nil, descriptor: [sortDescriptor])
            
        }
        
        fetch(self.fetchedResultsController)
        
        // refresh the table view
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.resultSearchController.isActive {
            return 1
        }else{
            let count = self.coursesDict.keys.count
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.resultSearchController.isActive {
            if let count = self.fetchedResultsController?.sections?[section].numberOfObjects {
                return count
            }else{
                return 1
            }
        }else{
            let sectionName = SectionsList[section]
            
            if let courses = self.coursesDict[sectionName] {
                return courses.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.resultSearchController.isActive {
            return ""
        }else{
            return SectionsList[section]
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.orange
    }
    
    //Note Do not use optional chaining
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "CourseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        var course: NSManagedObject
        
        if self.resultSearchController.isActive {
            course = self.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
            if let name = course.value(forKey: CourseName) as? String, let id = course.value(forKey: CourseCode) as? String, let units = course.value(forKey: CourseUnits) as? String  {
                cell.textLabel?.text = "\(name)   \(id)"
                cell.detailTextLabel?.text = "\(units) Units"
            }
            return cell
        }else{
            let sectionName = SectionsList[indexPath.section]
            if let courses = self.coursesDict[sectionName] {
                let course = courses[indexPath.row]
                if let name = course.value(forKey: CourseName) as? String, let id = course.value(forKey: CourseCode) as? String, let units = course.value(forKey: CourseUnits) as? String  {
                    cell.textLabel?.text = "\(name)   \(id)"
                    cell.detailTextLabel?.text = "\(units) Units"
                }
                return cell
            }
            return cell
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CourseDetailSegue" {
            if let CVC = segue.destination as? CourseDetailsViewController {
                if self.resultSearchController.isActive {
                    let cell = sender as! UITableViewCell
                    if let indexPath = self.tableView.indexPath(for: cell) {
                        let course = self.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
                        CVC.course = course
                    }
                }else{
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        let section = SectionsList[indexPath.section]
                        if let courses = self.coursesDict[section] {
                            let course = courses[indexPath.row]
                            CVC.course = course
                        }
                    }// end if inedxPath
                }
            }// end if CVC
        }//end if segue
    }// end if segue
    
}
