//
//  AreasTableViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/10/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class AreasTableViewController: UITableViewController {
    
    private var hud: MBProgressHUD?
    private var context = {
        AppDelegate.viewContext
    }()
    
    var areas: [Area] = [] {
        didSet{
            if areas.count == 0 {
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchAreas()
    }
    
    fileprivate func fetchAreas(){
        
        self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
        
        let fetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: AreaName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            self.areas = try self.context.fetch(fetchRequest)
            self.hud?.hide(animated: true)
        }catch let error as NSError{
            _ = ProgressHUD.displayMessage("Could not fetch Areas: \(error.localizedDescription)", fromView: self.view)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath) as! AreasTableViewCell
        
        // Configure the cell...
        let area = self.areas[indexPath.row]
        if let name = area.value(forKey: AreaName) as? String, let title = area.value(forKey: AreaTitle) as? String, let descript = area.value(forKey: AreaDescript) as? String  {
            cell.areaName?.text = name
            cell.areaTitle?.text = title
            cell.areaDescription?.text = descript
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AreaDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                if let navController = segue.destination as? UINavigationController {
                    let AVC = navController.topViewController as! AreaViewController
                    AVC.area = self.areas[indexPath.row]
                }else {
                    let AVC = segue.destination as! AreaViewController
                    AVC.area = self.areas[indexPath.row]
                }
            }// end if segue
        }
    }// end func
    
}


