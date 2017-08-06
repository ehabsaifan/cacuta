//
//  AnnouncementsViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/26/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit

enum AnnouncmenetsDisplayType : Int {
    case localType = 0
    case publlicType = 1
    case savedType = 2
}

class AnnouncementsDisplayViewController: UIViewController {

    var publicViewController : PublicTableViewController?
    var localViewController : LocalTableViewController?
    var savedViewController : SavedTableViewController?
    
    
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var selectionBar: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case AnnouncmenetsDisplayType.savedType.rawValue:
            self.savedViewController?.isSelected = true
            self.savedView?.isHidden = false
            self.publicViewController?.isSelected = false
            self.publicView?.isHidden = true
            self.localView?.isHidden = true
        case AnnouncmenetsDisplayType.publlicType.rawValue:
            self.publicViewController?.isSelected = true
            self.publicView?.isHidden = false
            self.savedViewController?.isSelected = false
            self.savedView?.isHidden = true
            self.localView?.isHidden = true
        case AnnouncmenetsDisplayType.localType.rawValue:
            self.localView?.isHidden = false
            self.publicView?.isHidden = true
            self.savedView?.isHidden = true
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
            case "PublicSegue":
                self.publicViewController = segue.destination as? PublicTableViewController
            case "LocalSegue" :
                self.localViewController = segue.destination as? LocalTableViewController
            case "SavedSegue" :
                self.savedViewController = segue.destination as? SavedTableViewController
            default:
                Void()
            }
        }
    }
    
}
