//
//  AboutTableViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import SafariServices

private enum Rows : Int {
    case stdPortalRow, igetcRow, assistRow
}

class AboutTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row{
        case Rows.stdPortalRow.rawValue:
            if let url = STDPORTAL {
                self.openSafari(url as URL)
            }
        case Rows.igetcRow.rawValue:
            if let url = IGETC {
                self.openSafari(url as URL)
            }
        case Rows.assistRow.rawValue:
            if let url = ASSIST {
                self.openSafari(url as URL)
            }
        default:
            Void()
        }
    }

    fileprivate func openSafari(_ link: URL){
        if #available(iOS 9.0, *) {
            self.openSafariViewController(link)
            
        } else {
            UIApplication.shared.openURL(link)
        }
    }
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 9.0, *)
    func openSafariViewController(_ link: URL){
        let svc = SFSafariViewController(url: link, entersReaderIfAvailable: false)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)

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
