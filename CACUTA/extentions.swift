//
//  extentions.swift
//  UTA//
//  Created by Ehab Saifan on 6/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

extension UIView {
    func makeCircular() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}

extension String {
    
    var isEmptyField: Bool {
        return trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
    
    var trim: String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) == nil
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}


extension NSError{
    class func error(_ message : String, code: Int = 0) -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey : NSLocalizedString(message, comment: "")
        ]
        return NSError(domain: "STA", code: code, userInfo: userInfo)
    }
}





