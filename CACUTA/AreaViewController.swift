//
//  AreaViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/11/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit
import CoreData
import MBProgressHUD

class AreaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    fileprivate var hud: MBProgressHUD?
    private var fetchedResultsController: NSFetchedResultsController<Course>?
    
    fileprivate var resultSearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchBarViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var areaNotesTextView: UITextView!
    
    private var context = {
        return AppDelegate.viewContext
    }()
    
    var area: Area? {
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
        
        self.fetchedResultsController?.delegate = self
        self.update()
        self.initResultSearchController()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateView()
    }
    
    fileprivate func update(){
        self.areaNotesTextView?.text = area?.about
        self.areaName = area?.name
        
        self.navigationItem.title = self.areaName
        self.fetchCourses()
        
    }// end update
    
    fileprivate func fetchCourses(){
        
        if let areaName = self.areaName {
            
            let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
            
            let sortDescriptor1 = NSSortDescriptor(key: CourseSubArea, ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: CourseName, ascending: true)
            let predicate = NSPredicate(format: "%K == %@", CourseArea, areaName)
            
            fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
            fetchRequest.predicate = predicate
            
            self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
            
            self.fetchedResultsController = NSFetchedResultsController<Course>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: CourseSubArea, cacheName: "courses list")
            self.fetch(self.fetchedResultsController)
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
            
            // form the search format
            let predicate = NSPredicate(format: "%K CONTAINS[c] %@ AND %K == %@", CourseName, trimmedSearchString, CourseArea, areaName ?? "")
            
            // add the search filter
            self.fetchedResultsController?.fetchRequest.predicate = predicate
            self.fetch(self.fetchedResultsController)
        }
        else {
            self.fetchCourses()
        }
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.fetchedResultsController?.sections?[section].numberOfObjects {
            return count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.fetchedResultsController?.sections?[section].name
        return title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.orange
    }
    
    //Note Do not use optional chaining
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "CourseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let course = self.fetchedResultsController?.object(at: indexPath) {
            if let code = course.code, let name = course.name {
                cell.textLabel?.text = "\(name)   \(code)"
            }
            if let units = course.numOfUnits {
                cell.detailTextLabel?.text = "\(units) Units"
            }else{
                cell.detailTextLabel?.text = "N/A"
            }
        }
        
            return cell
        }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CourseDetailSegue" {
            if let CVC = segue.destination as? CourseDetailsViewController {
                let cell = sender as! UITableViewCell
                if let indexPath = self.tableView.indexPath(for: cell) {
                    let course = self.fetchedResultsController?.object(at: indexPath)
                    CVC.course = course
                    }// end if inedxPath
            }// end if CVC
        }//end if segue
    }// end if segue
    
}
