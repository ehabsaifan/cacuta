//
//  ImagePickerManager.swift
//  CACUTA
//  Created by Ehab Saifan on 6/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias ImagePickerCompletion = ((_ image : UIImage?) -> Void)?

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    fileprivate var completion : ImagePickerCompletion = nil
    fileprivate var presenter : UIViewController?
    
    class var currentManager : ImagePickerManager  {
        struct Static {
            static let instance : ImagePickerManager = ImagePickerManager()
        }
        return Static.instance
    }
    
    class func displayImages(_ presenter : UIViewController, completion : ImagePickerCompletion) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            ImagePickerManager.currentManager.completion = completion
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = ImagePickerManager.currentManager
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            ImagePickerManager.currentManager.presenter = presenter
            presenter.present(imagePicker, animated: true,
                                            completion: nil)
        }
        else{
            if let completion = completion{
                completion(nil)
            }
        }
    }
    
    class func displayLibrary(_ presenter : UIViewController, completion : ImagePickerCompletion){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            ImagePickerManager.currentManager.completion = completion
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = ImagePickerManager.currentManager
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            ImagePickerManager.currentManager.presenter = presenter
            presenter.present(imagePicker, animated: true,
                                            completion: nil)
        }
        else{
            if let completion = completion{
                completion(nil)
            }
        }
        
    }
    
    //MARK: private
    fileprivate func dismiss(_ completion:(()->())? = nil){
        self.presenter?.dismiss(animated: true, completion: { () -> Void in
            if let completion = completion{
                completion()
            }
        })
        self.presenter = nil
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        if(picker.sourceType == UIImagePickerControllerSourceType.camera){
            // Access the uncropped image from info dictionary
            if let imageToSave: UIImage = editingInfo[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            }
        }
        self.dismiss { () -> () in
            if let completion = self.completion{
                completion(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss { () -> () in
            if let completion = self.completion{
                completion(nil)
            }
        }
    }
    
    
}
