//
//  UniversityTableViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/14/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

class UniversityTableViewController: UITableViewController {
    
    @IBOutlet weak var uni_background: UIImageView!
    
    @IBOutlet weak var uni_desc: UILabel!
    @IBOutlet weak var uni_city: UILabel!
    @IBOutlet weak var uni_rank: UILabel!
    @IBOutlet weak var uni_avgpa: UILabel!
    @IBOutlet weak var uni_logo: UIImageView!
    
    var Univ: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    fileprivate func update(){
        
        //self.uni_desc?.setContentOffset(CGPoint(x: 100, y: 100), animated: true)
        
        // Get the image of the university
        if let name = self.Univ?.value(forKey: UnivAcron) as? String {
            self.self.uni_logo?.image = UIImage(named: "\(name)Logo")
            self.self.uni_background?.image = UIImage(named: "\(name)")
        }
        
        // Get the description of the university, and clean it up
        self.uni_desc?.text = self.Univ?.value(forKey: UnivDescript) as? String
        
        // Get university rank
        self.uni_rank?.text = self.Univ?.value(forKey: UnivRank) as? String
        
        // Get university Average GPA
        self.uni_avgpa?.text = self.Univ?.value(forKey: UnivAGPA) as? String
        
        // Get city name only
        let uc_title  = "University of California - "
        // Trim university title to city only
        let startIndx = uc_title.endIndex
        let uc_name  = self.Univ?.value(forKey: UnivName) as? String
        self.uni_city?.text = uc_name?.substring(from: startIndx)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func uni_weblink(_ sender: AnyObject) {
        // Get university URL/website
        if let url_link = self.Univ?.value(forKey: UnivURL) as? String, let url = URL(string: url_link) {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < -100.0) {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.tableView.transform = self.tableView.transform.translatedBy(x: 0.0, y: self.tableView.bounds.height - 100.0)
                }, completion: { (done:Bool) -> Void in
                    self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
}

