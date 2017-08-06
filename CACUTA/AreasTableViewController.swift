//
//  AreasTableViewController.swift
//  UTA//
//  Created by Ehab Saifan on 6/10/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class AreasTableViewController: UITableViewController {
    
    fileprivate var hud: MBProgressHUD?
    
    var areas: [NSManagedObject] = [] {
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.Area.rawValue)
        let sortDescriptor = NSSortDescriptor(key: AreaName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        
        DataBaseManager.fetchRequest(fetchRequest, completion: { (result, error) in
            if let results = result {
                self.areas = results
                self.hud?.hide(true)
            }else if let error = error{
                ProgressHUD.displayMessage("Could not fetch Areas: \(error), \(error.userInfo)", fromView: self.view)
            }
        })
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
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


