//
//  ListsTableTableViewController.swift
//
//
//  Created by Ehab Saifan on 6/10/16.
//
//

import UIKit
import CoreData
import MBProgressHUD

class ListTableTableViewController: UITableViewController, UISearchResultsUpdating{
    
    var classes: [NSManagedObject] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var isSelected : Bool = true{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    fileprivate var hud: MBProgressHUD?
    fileprivate var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    fileprivate var resultSearchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        self.initResultSearchController()
        self.fetchCourses()
    }
    
    fileprivate func fetchCourses(){
        
        let sortDescriptor = NSSortDescriptor(key: CourseName, ascending: true)
        
        self.fetchedResultsController = DataManager.fetchedResultController(Entities.Course, predicate: nil, descriptor: [sortDescriptor])
        
        // pull out core data records
        self.fetch(self.fetchedResultsController)
        
        self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.Course.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        DataManager.fetchRequest(fetchRequest, completion: { (result, error) in
            if let results = result {
                self.classes = results
                self.hud?.hide(animated: true)
            }else if let error = error{
                _ = ProgressHUD.displayMessage("Could not fetch Courses: \(error), \(error.userInfo)", fromView: self.view)
            }
        })
    }
    
    fileprivate func initResultSearchController(){
        // initialize search controller after the core data
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.hidesNavigationBarDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        // places the built-in searchbar into the header of the table
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.resultSearchController.isActive {
            if let count = self.fetchedResultsController?.sections?[section].numberOfObjects {
                return count
            }else{
                return 1
            }
        }else{
            return self.classes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesListCell", for: indexPath)
        var course: NSManagedObject
        
        if self.resultSearchController.isActive {
            course = self.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
        }else{
            course = self.classes[indexPath.row]
        }
        
        cell.textLabel?.text = course.value(forKey: CourseName) as? String
        if let units = course.value(forKey: CourseUnits) as? String {
            cell.detailTextLabel?.text = "\(units) Units"
        }else{
            cell.detailTextLabel?.text = "N/A"
        }
        
        return cell
    }
    
    
    // updates the table view with the search results as user is typing...
    func updateSearchResults(for searchController: UISearchController) {
        
        // process the search string, remove leading and trailing spaces
        let searchText = searchController.searchBar.text!
        let trimmedSearchString = searchText.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // if search string is not blank
        if !trimmedSearchString.isEmpty {
            
            // form the search format
            let predicate = NSPredicate(format: "%K CONTAINS[c] %@", CourseName, trimmedSearchString)
            
            // add the search filter
            self.fetchedResultsController?.fetchRequest.predicate = predicate
        }
        else {
            
            let sortDescriptor = NSSortDescriptor(key: CourseName, ascending: true)
            
            self.fetchedResultsController = DataManager.fetchedResultController(Entities.Course, predicate: nil, descriptor: [sortDescriptor])
            
        }
        
        fetch(self.fetchedResultsController)
        
        // refresh the table view
        self.tableView.reloadData()
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CourseDetailSegue" {
            if let CVC = segue.destination as? CourseDetailsViewController {
                let cell = sender as! UITableViewCell
                if let indexPath = self.tableView.indexPath(for: cell) {
                    let course = self.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
                    CVC.course = course
                }
            }// end if
        }//end if indexPath
    }// end if segue
    
}
