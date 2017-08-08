//
//  EditProfileViewController.swift
//  CACUTA
//  Created by Ehab Saifan on 6/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import CoreData


class EditProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var gpaField: UITextField!
    @IBOutlet weak var univPickerView: UIPickerView!
    
    var univ: [String] = ["TBD"] {
        didSet {
            if let picker = self.univPickerView {
                picker.reloadAllComponents()
                self.univPickerView?.selectRow(self.univ.count/2 , inComponent: 0, animated: true)
            }
        }
    }
    
    private var context = {
        AppDelegate.viewContext
    }()
    
    var acrons: [String] = ["TBD"]
    
    var selectedUniv = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserLoggedOutNotification), object: nil, queue: OperationQueue.main) { (NSNotification) in
            self.profileImage.image = UIImage(named: "user")
            self.nameField.text = "Student"
            self.gpaField.text = "N/A"
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.gpaField.resignFirstResponder()
        self.nameField.resignFirstResponder()
    }
    
    fileprivate func setup() {
        
        self.profileImage.makeCircular()
        self.nameField.tag = 0
        self.gpaField.tag = 1
        
        self.fetchStdInfo()
        self.fetchUniv()
    }
    
    fileprivate func fetchStdInfo() {
        if DataManager.currentManager.isAuthenticated {
            if let name = User.currentUser.name{
                self.nameField?.text = name
            }
            
            if let gpa = User.currentUser.gpa{
                self.gpaField?.text = "\(gpa)"
            }
            
            if let image = User.currentUser.profileImage {
                self.profileImage?.image = image
            }else{
                self.profileImage?.image = UIImage(named: "user")
            }
            
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
        self.univPickerView?.reloadAllComponents()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let name = self.nameField?.text
        let gpa = Double(self.gpaField?.text ?? "")
        let university = self.selectedUniv
        let image = self.profileImage?.image
        User.currentUser.updateUserInfo(name: name, gpa: gpa, university: university, image: image) { (success, error) in
            if success {
                delay(0.5) {
                    self.dismiss(animated: true, completion: nil)
                }
            }else if let error = error {
                _ = ProgressHUD.displayMessage(error.localizedDescription, fromView: self.view)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        if string.characters.count == 0 {
            return true
        }
        
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == self.gpaField {
            if let text = textField.text {
                print("\(text)")
                switch prospectiveText.characters.count {
                case 1:
                    return string.containsOnlyCharactersIn("01234")
                case 2:
                    return string.containsOnlyCharactersIn(".")
                case 3:
                    return string.containsOnlyCharactersIn("0123456789")
                case 4:
                    return string.containsOnlyCharactersIn("0123456789")
                default:
                    return false
                }// end switch
            }// end if let
        }// end text field
        return true
    }
    
    
    @IBAction func editImagePressed(_ sender: UITapGestureRecognizer) {
        
        let actionSheet =  UIAlertController(title: NSLocalizedString("would you like to change your profile image?", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            ImagePickerManager.displayImages(self) { [weak self] (image) -> Void in
                if let image = image {
                    self?.profileImage?.image = image
                }//end if
            }
        })
        
        let libraryPhotoAction = UIAlertAction(title: NSLocalizedString("Choose From Library", comment: ""), style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            ImagePickerManager.displayLibrary(self) { [unowned self] (image) -> Void in
                if let image = image  {
                    self.profileImage?.image = image
                }//end if
            }
            
        })
        
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(libraryPhotoAction)
        actionSheet.addAction(doneAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    // Gesture Recognizer func called when press outside textfields
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.nameField.resignFirstResponder()
        self.gpaField.resignFirstResponder()
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
    
    // UIPickerView Delgate Methods
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.univ.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.univ[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        
        pickerLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        pickerLabel?.text = self.univ[row]
        pickerLabel?.textColor = UIColor.orange
        pickerLabel?.numberOfLines = 2
        pickerLabel?.textAlignment = .center
        pickerLabel?.lineBreakMode = .byWordWrapping
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedUniv = self.acrons[row]
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
