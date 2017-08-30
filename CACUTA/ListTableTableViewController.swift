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

class ListTableTableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {
    
    var courses: [Course] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var isSelected : Bool = true{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    private var context = {
        return AppDelegate.viewContext
    }()
    
    private var hud: MBProgressHUD?
    private var fetchedResultsController: NSFetchedResultsController<Course>?
    
    private var resultSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        self.fetchedResultsController?.delegate = self
        self.initResultSearchController()
        self.fetchCourses()
    }
    
    fileprivate func fetchCourses(){
        
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: CourseName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
        
        self.fetchedResultsController = NSFetchedResultsController<Course>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetch(self.fetchedResultsController)
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

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.fetchedResultsController?.sections?[section].numberOfObjects {
            return count
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesListCell", for: indexPath)
        
        if let course = self.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = course.name
            if let units = course.numOfUnits {
                cell.detailTextLabel?.text = "\(units) Units"
            }else{
                cell.detailTextLabel?.text = "N/A"
            }
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
            let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: CourseName, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            self.fetchedResultsController = NSFetchedResultsController<Course>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        }
        
        self.fetch(self.fetchedResultsController)
    }
    
    // update the contents of a fetch results controller
    private func fetch(_ frcToFetch: NSFetchedResultsController<Course>?) {
        if let frc = frcToFetch {
            do {
                try frc.performFetch()
                self.tableView?.reloadData()
            } catch {
                return
            }
        }
        self.hud?.hide(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CourseDetailSegue" {
            if let CVC = segue.destination as? CourseDetailsViewController {
                let cell = sender as! UITableViewCell
                if let indexPath = self.tableView.indexPath(for: cell) {
                    let course = self.fetchedResultsController?.object(at: indexPath)
                    CVC.course = course
                }
            }// end if
        }//end if indexPath
    }// end if segue
    
}
