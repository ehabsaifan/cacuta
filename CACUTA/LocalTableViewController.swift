//
//  LocalTableViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class LocalTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = LocalAnnouncments["Announcments"]?.count {
            return count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if let announcment = LocalAnnouncments["Announcments"]?[indexPath.row] {
            
            cell.textLabel?.text = announcment[Publisher]
            cell.detailTextLabel?.text = announcment[Details]
        }
        
        // Configure the cell...

        return cell
    }

       // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAnnouncmentSegue" {
            if let vc = segue.destination as? AnnouncmentViewController {
                let cell = sender as! UITableViewCell
                if let indexPath = self.tableView.indexPath(for: cell) {
                    vc.announcment = LocalAnnouncments["Announcments"]?[indexPath.row]
                }// end indexPath
            }// end VC
        }
    }

}
