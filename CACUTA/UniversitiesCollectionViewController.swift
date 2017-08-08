//
//  UniversitiesCollectionViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/14/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

private let reuseIdentifier = "UniCell"

class UniversitiesCollectionViewController: UICollectionViewController {
    
    fileprivate var hud: MBProgressHUD?
    fileprivate var logos: [String?] = []
    
    fileprivate var Universities: [University] = []
    
    var context = {
        return AppDelegate.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // this is to fix the issue of cell gets underneath the TabBar
        let buttomOfSet = self.bottomLayoutGuide.length + 10
        let topOfSet = self.topLayoutGuide.length + 10
        self.collectionView?.contentInset = UIEdgeInsets(top: topOfSet, left: 10, bottom: buttomOfSet, right: 10)
        
        self.getLogos()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getLogos()
    }
    
    fileprivate func getLogos(){
        
        self.hud = ProgressHUD.displayProgress("Loading", fromView: self.view)
        
        self.logos = []

        let fetchRequest : NSFetchRequest<University> = University.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: UnivAcron, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            self.Universities = try self.context.fetch(fetchRequest)
            for university in self.Universities {
                if let acr = university.acronym {
                    self.logos.append("\(acr)Logo")
                }
            }// end for
            self.hud?.hide(animated: true)
        }catch let error as NSError{
             _ = ProgressHUD.displayMessage("Could not fetch universities info: \(error.localizedDescription)", fromView: self.view)
        }
        self.collectionView?.reloadData()
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.logos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UniversityCollectionViewCell
        
        // Configure the cell
        if let logo = self.logos[indexPath.row]{
            cell.Uni_logo?.image = UIImage(named: logo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.bounds.width/2 - 16
        
        return CGSize(width: w, height: w)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check for indexpath and cell
        if let cell = collectionView.cellForItem(at: indexPath) {
            
            // Conduct segue
            performSegue(withIdentifier: "UniDetailSegue", sender: cell)
            
        } else {
            // Call Error
            print("Segue process failed hard!")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier ==  "UniDetailSegue" {
            if let indexPath = collectionView?.indexPath(for: sender as! UniversityCollectionViewCell){
                if let navController = segue.destination as? UINavigationController {
                    let AVC = navController.topViewController as! UniversityTableViewController
                    AVC.Univ = self.Universities[indexPath.row]
                }else {
                    let AVC = segue.destination as! UniversityTableViewController
                    AVC.Univ = self.Universities[indexPath.row]
                }
            }// end if segue
        }
    }
}
