//
//  AnnouncmentViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AnnouncmentViewController: UIViewController {
    
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var addFavoritebBtnLabel: UIButton!
    @IBOutlet weak var card: UIView!
    
    var announcment :[String:String]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.card.layer.cornerRadius = 15.0
        self.card.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = false
        
        self.fetchAnnouncment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAnnouncment()
    }
    
    fileprivate func fetchAnnouncment() {
        if let announcement = self.announcment, announcment?.keys.count > 0 {
            self.publisherNameLabel?.text = announcement[Publisher]
            self.headlineLabel?.text = announcement[HeadLine]
            self.detailsLabel?.text = announcement[Details]
            self.dateLabel?.text = self.getDate(announcement[Date])
        }
    }
    
    fileprivate func getDate(_ date: String?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let dateObj = dateFormatter.date(from: date) {
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .medium
                let dateString = dateFormatter.string(from: dateObj)
                return dateString
            }
            return "Date N/A"

        }
        return "Date N/A"
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharePressed(_ sender: AnyObject) {
        
        if let publisher = self.publisherNameLabel?.text, let date = self.dateLabel?.text, let headline = self.headlineLabel?.text, let details = self.detailsLabel?.text {
            
            var objectsToShare = [AnyObject]()
            
            let textToShare = "Publisher: \(publisher)\nDate: \(date)\n\nTitle: \(headline)\n\n\n\(details)"
            
            objectsToShare = [textToShare as AnyObject]
            
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToFavoritePressed(_ sender: AnyObject) {
        _ = ProgressHUD.displayMessage("Saved", fromView: self.view)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
