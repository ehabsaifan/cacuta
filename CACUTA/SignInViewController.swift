//
//  SignInViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var stdIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signinBtn: UIButton!
    private var context = {
        AppDelegate.viewContext
    }()
    
    var id: String? {
        didSet {
            if let id = id {
                self.stdIDField?.text = id
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stdIDField.tag = 0
        self.passwordField.tag = 1
        self.stdIDField.becomeFirstResponder()
        self.signinBtn.makeCircularEdges()
        
        if let id = id {
            self.stdIDField?.text = id
        }
    }
    
    @IBAction func signinPressed(_ sender: UIButton) {
        if let id = self.stdIDField.text, !id.isEmpty, let password = self.passwordField.text, !password.isEmpty {
            
            let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
            let predicate = NSPredicate(format: "%K == %@", StdID, id)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                if let student = try self.context.fetch(fetchRequest).first {
                    User.currentUser.fetchUserInfo(student)
                    DataManager.currentManager.isAuthenticated = true
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }else{
                    _ = ProgressHUD.displayMessage("No account found! Please sign up first", fromView: self.view)
                    delay(1.2, closure: {
                        let presenter = self.presentingViewController
                        presenter?.dismiss(animated: true, completion: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpController") as! SignUpViewController
                            presenter?.present(vc, animated: true, completion: nil)
                        })// end dismiss
                    })// end delay
                }
            } catch let error as NSError {
                _ = ProgressHUD.displayMessage("Could not fetch student: \(error.localizedDescription)", fromView: self.view)
            }
        }// end if let
        else {
            _ = ProgressHUD.displayMessage("Please fill all fields & choose your current college", fromView: self.view)
        }
    }// end signinPressed
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Gesture Recognizer func called when press outside textfields
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.stdIDField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
    
    // Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder? = textField.superview!.viewWithTag(nextTag){
            nextResponder?.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            self.hideKeyboard(textField)
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    
}
