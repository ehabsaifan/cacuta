//
//  SignUpViewController.swift
//  CACUTA
//
//  Created by Ehab Saifan on 6/20/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var stdIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var context = {
        AppDelegate.viewContext
    }()
    
    var univ: [String] = ["TBD"] {
        didSet {
            if let picker = self.pickerView {
                picker.reloadAllComponents()
                self.pickerView?.selectRow(CollegesList.count/2 , inComponent: 0, animated: true)
                self.pickerView?.selectRow(self.univ.count/2 , inComponent: 1, animated: true)
            }
        }
    }
    
    var acrons: [String] = ["TBD"]
    
    var selectedUniv = ""
    var selectedColg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedColg = CollegesList[CollegesList.count/2]
        self.nameField.tag = 0
        self.stdIDField.tag = 1
        self.passwordField.tag = 2
        self.nameField.becomeFirstResponder()
        self.fetchUniv()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goPressed(_ sender: UIButton) {
        
        if let name = self.nameField.text, !name.isEmpty, let id = self.stdIDField.text, !id.isEmpty, let password = self.passwordField.text, !password.isEmpty {
            
            guard let college = self.selectedColg, !college.isEmpty else{
                _ = ProgressHUD.displayMessage("Please fill all fields & choose your current college", fromView: self.view)
                return
            }
            
            var info: [String: String] = [:]
            info[StdName] = name.trim
            info[StdGPA] = "\(0)"
            info[StdPassword] = password
            info[StdID] = id
            info[StdCollege] = self.selectedColg
            info[StdUnivChoive] = self.selectedUniv
            
            if self.isStudentExist(id) {
                _ = ProgressHUD.displayMessage("Account already exists! Please sign in", fromView: self.view)
                delay(1.2, closure: {
                    
                    let presenter = self.presentingViewController
                    presenter?.dismiss(animated: true, completion: {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInController") as! SignInViewController
                        presenter?.present(vc, animated: true, completion: nil)
                    })// end dismiss
                })// end delay
            }else {
                DataManager.initUser(info, completion: { (success, error) in
                    if success {
                        DataManager.currentManager.isAuthenticated = true
                        User.currentUser.setUserInfo(info)
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }else if let error = error {
                        _ = ProgressHUD.displayMessage("Could not register: \(error), \(error.userInfo)", fromView: self.view)
                    }
                })
            }// end if isStudentExist()
        }// end if let
        else {
            _ = ProgressHUD.displayMessage("Please fill all fields & choose your current college", fromView: self.view)
        }
        
    }
    
    fileprivate func isStudentExist(_ id: String) -> Bool{

        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", StdID, id)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            return try self.context.fetch(fetchRequest).count > 0
        }catch let error as NSError {
            _ = ProgressHUD.displayMessage("Could not register: \(error.localizedDescription)", fromView: self.view)
            return false
        }
    }
    
    fileprivate func fetchUniv() {
        let fetchRequest : NSFetchRequest<University> = University.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: UnivName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let universities = try self.context.fetch(fetchRequest)
            for university in universities {
                if let acr = university.acronym, let name = university.name {
                    self.univ.append(name)
                    self.acrons.append(acr)
                }
            }// end for
        }catch let error as NSError{
            _ = ProgressHUD.displayMessage("Could not fetch universities info: \(error.localizedDescription)", fromView: self.view)
        }
        self.pickerView?.reloadAllComponents()
    }
    
    
    // UIPickerView Delgate Methods
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return CollegesList.count
        }else{
            return self.univ.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return CollegesList.sorted()[row]
        }else{
            return self.univ[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        
        pickerLabel?.font = UIFont(name:"HelveticaNeue", size: 14.0)
        pickerLabel?.textColor = UIColor.orange
        pickerLabel?.numberOfLines = 2
        pickerLabel?.textAlignment = .center
        pickerLabel?.lineBreakMode = .byWordWrapping
        
        if component == 0 {
            pickerLabel?.text = CollegesList.sorted()[row]
        }else{
            pickerLabel?.text = self.univ[row]
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.selectedColg = CollegesList.sorted()[row]
        }else{
            self.selectedUniv = self.acrons[row]
        }
    }
    
    
    // Gesture Recognizer func called when press outside textfields
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.nameField.resignFirstResponder()
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
