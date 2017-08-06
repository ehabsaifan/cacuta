//
//  helpers.swift
//  UTA//
//  Created by Ehab Saifan on 6/13/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit
import MBProgressHUD

class ProgressHUD: NSObject {
    //    private var hud : UIView?
    
    class func displayMessage(_ text: String?, fromView : UIView?, mode : MBProgressHUDMode = .text, delayTime : Double = 1.2, completion : (() -> Void)? = nil) -> MBProgressHUD?{
        
        if let fromView = fromView, let text = text {
            let hud = MBProgressHUD.showAdded(to: fromView, animated: true)
            hud.layer.zPosition = 1
            hud.mode = mode
            hud.detailsLabelText = NSLocalizedString(text, comment: "")
            hud.detailsLabelFont = hud.labelFont
            delay(delayTime, closure: {() -> () in
                hud.hide(true)
                if (completion != nil){
                    completion!()
                }
            })
            return hud
        }
        return nil
    }
    
    class func displayProgress(_ text: String?, fromView : UIView?, completion : (() -> Void)? = nil) -> MBProgressHUD?{
        
        return self.displayMessage(text, fromView: fromView, mode: .indeterminate, delayTime: 60, completion: completion)
    }
}


func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}