//
//  DisplayCoursesViewController.swift
//  UTA//
//  Created by Ehab Saifan on 6/17/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

enum CoursesDisplayType : Int {
    case areaType = 0
    case listType = 1
}

class DisplayCoursesViewController: UIViewController {
    
    var listViewController : ListTableTableViewController?
    var areaViewController : AreasTableViewController?
    
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var areaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case CoursesDisplayType.listType.rawValue:
            self.listView.isHidden = false
            self.listViewController?.isSelected = true
            self.areaView.isHidden = true
        case CoursesDisplayType.areaType.rawValue:
            self.listView.isHidden = true
            self.areaView.isHidden = false
        default:
            Void()
        }
    }
    
    @IBAction func calcenlTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            switch identifier{
            case "ListSegue":
                self.listViewController = segue.destination as? ListTableTableViewController
            case "AreasSegue" :
                self.areaViewController = segue.destination as? AreasTableViewController
            default:
                Void()
            }
        }
    }
    
}
