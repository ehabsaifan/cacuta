//
//  MoreTableViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/19/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import MessageUI

private enum Rows : Int {
    case profileRow, announcementstRow, shareRow, settingsRow, aboutRow, signInRow
}

class MoreTableViewController: UITableViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logo.makeCircular()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            
            self.loginLabel?.text = "Log In"
            self.loginImageView?.image = UIImage(named: "signOut")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedInNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.loginLabel?.text = "Log Out"
            self.loginImageView?.image = UIImage(named: "login")
        }
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLoginText()
    }
    
    private func updateLoginText(){
        if DataManager.currentManager.isAuthenticated{
            self.loginLabel?.text = "Log Out"
            self.loginImageView?.image = UIImage(named: "login")
        }else {
            self.loginLabel?.text = "Log In"
            self.loginImageView?.image = UIImage(named: "signOut")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row{
        case Rows.shareRow.rawValue:
            self.shareInfo()
        case Rows.signInRow.rawValue:
            self.toggleLogin()
        default:
            Void()
        }
    }
    
    private func shareInfo(){
        var objectsToShare = [AnyObject]()
        var textToShare = ""
        if let gpa = User.currentUser.gpa {
            textToShare = "My Curren GPA \(gpa)"
            objectsToShare.append(textToShare as AnyObject)
        }
        if let myWebsite = ASSIST {
            objectsToShare.append(myWebsite as AnyObject)
        }
        
        objectsToShare = [textToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func toggleLogin(){
        if DataManager.currentManager.isAuthenticated{
            DataManager.currentManager.isAuthenticated = false
        }else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SignInController") as? SignInViewController {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
}

extension MoreTableViewController: MFMailComposeViewControllerDelegate {
    
    //MARK: message delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
