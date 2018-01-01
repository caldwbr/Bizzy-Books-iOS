//
//  AllowedCharsTextField.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/30/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

// 1
class AllowedCharsTextField: UITextField, UITextFieldDelegate {
    
    var thisIsTheAmt = TheAmtSingleton.shared
    let formatter = NumberFormatter()
    var numberKind = Int()
    var isNegative = false
    var identifier = 0
    
    // 2
    @IBInspectable var allowedChars: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 3
        self.delegate = self
        // 4
        //autocorrectionType = .no
        self.placeholder = updateAmount()
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale.current
    }
    
    func setOdo() {
        let amount = Double(thisIsTheAmt.theOdo)
        self.text = formatter.string(from: NSNumber(value: amount))
    }
    
    func setText() {
        let amount = Double(thisIsTheAmt.theStartingBal/100) + Double(thisIsTheAmt.theStartingBal%100)/100
        self.text = formatter.string(from: NSNumber(value: amount))
    }
    
    // 5
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 6
        /* // This stupid thing was preventing backspaces from having effect on amt!
        guard string.count > 0 else {
            return true
        }*/
        
        // 7
        let allowedCharsSet = CharacterSet(charactersIn: allowedChars)
        let invertedAllowedCharsSet = allowedCharsSet.inverted
        //let prospectiveTextAsCharSet = CharacterSet.init(charactersIn: prospectiveText)
        let stringyAsCharSet = CharacterSet.init(charactersIn: string)
        if stringyAsCharSet.isDisjoint(with: invertedAllowedCharsSet) {
            switch self.identifier {
            case 3:
                if let digit = Int(string) {
                    if thisIsTheAmt.theStartingBal > 10_000_000_00 {
                        thisIsTheAmt.theStartingBal = 0
                        self.text = ""
                        return false
                    }
                    if isNegative {
                        thisIsTheAmt.theStartingBal = thisIsTheAmt.theStartingBal * 10 - digit
                    } else {
                        thisIsTheAmt.theStartingBal = thisIsTheAmt.theStartingBal * 10 + digit
                    }
                    self.text = updateAmount()
                }
                if string == "" {
                    thisIsTheAmt.theStartingBal = thisIsTheAmt.theStartingBal/10
                    self.text = thisIsTheAmt.theStartingBal == 0 ? "" : updateAmount()
                }
                if string == "-" {
                    isNegative = !isNegative // Flips it
                    thisIsTheAmt.theStartingBal = -thisIsTheAmt.theStartingBal
                    self.text = updateAmount()
                }
                return false //This was the line that, when set to true, was appending the digit-in-purgatory after field had already been rendered by "updateAmount()" IE $0.055
            case 2:
                if let digit = Int(string) {
                    if thisIsTheAmt.theOdo > 1_000_000_000 {
                        thisIsTheAmt.theOdo = 0
                        self.text = ""
                        return false
                    }
                    if isNegative {
                        thisIsTheAmt.theOdo = thisIsTheAmt.theOdo * 10 - digit
                    } else {
                        thisIsTheAmt.theOdo = thisIsTheAmt.theOdo * 10 + digit
                    }
                    self.text = updateAmount()
                }
                if string == "" {
                    thisIsTheAmt.theOdo = thisIsTheAmt.theOdo/10
                    self.text = thisIsTheAmt.theOdo == 0 ? "" : updateAmount()
                }
                if string == "-" {
                    isNegative = !isNegative // Flips it
                    thisIsTheAmt.theOdo = -thisIsTheAmt.theOdo
                    self.text = updateAmount()
                }
                return false //This was the line that, when set to true, was appending the digit-in-purgatory after field had already been rendered by "updateAmount()" IE $0.055
            case 1:
                if let digit = Int(string) {
                    if thisIsTheAmt.howMany > 10_000_000_00 {
                        thisIsTheAmt.howMany = 0
                        self.text = ""
                        return false
                    }
                    if isNegative {
                        thisIsTheAmt.howMany = thisIsTheAmt.howMany * 10 - digit
                    } else {
                        thisIsTheAmt.howMany = thisIsTheAmt.howMany * 10 + digit
                    }
                    self.text = updateAmount()
                }
                if string == "" {
                    thisIsTheAmt.howMany = thisIsTheAmt.howMany/10
                    self.text = thisIsTheAmt.howMany == 0 ? "" : updateAmount()
                }
                if string == "-" {
                    isNegative = !isNegative // Flips it
                    thisIsTheAmt.howMany = -thisIsTheAmt.howMany
                    self.text = updateAmount()
                }
                return false //This was the line that, when set to true, was appending the digit-in-purgatory after field had already been rendered by "updateAmount()" IE $0.055
            default:
                if let digit = Int(string) {
                    
                    if thisIsTheAmt.theAmt > 10_000_000_00 {
                        thisIsTheAmt.theAmt = 0
                        self.text = ""
                        return false
                    }
                    if isNegative {
                        thisIsTheAmt.theAmt = thisIsTheAmt.theAmt * 10 - digit
                    } else {
                        thisIsTheAmt.theAmt = thisIsTheAmt.theAmt * 10 + digit
                    }
                    self.text = updateAmount()
                }
                if string == "" {
                    thisIsTheAmt.theAmt = thisIsTheAmt.theAmt/10
                    self.text = thisIsTheAmt.theAmt == 0 ? "" : updateAmount()
                }
                if string == "-" {
                    isNegative = !isNegative // Flips it
                    thisIsTheAmt.theAmt = -thisIsTheAmt.theAmt
                    self.text = updateAmount()
                }
                return false //This was the line that, when set to true, was appending the digit-in-purgatory after field had already been rendered by "updateAmount()" IE $0.055
            }
            
        }
        return false
    }
    
    func updateAmount() -> String? {
        switch self.identifier {
        case 3:
            let amount = Double(thisIsTheAmt.theStartingBal/100) + Double(thisIsTheAmt.theStartingBal%100)/100
            return formatter.string(from: NSNumber(value: amount))
        case 2:
            let amount = Double(thisIsTheAmt.theOdo)
            return formatter.string(from: NSNumber(value: amount))
        case 1: // Fuel up case
            let amount = Double(thisIsTheAmt.howMany/1000) + Double(thisIsTheAmt.howMany%1000)/1000
            return formatter.string(from: NSNumber(value: amount))
        default:
            switch numberKind {
            case 0:
                let amount = Double(thisIsTheAmt.theAmt/100) + Double(thisIsTheAmt.theAmt%100)/100
                return formatter.string(from: NSNumber(value: amount))
            case 1:
                let amount = Double(thisIsTheAmt.theAmt/1000) + Double(thisIsTheAmt.theAmt%1000)/1000
                return formatter.string(from: NSNumber(value: amount))
            case 2:
                let amount = Double(thisIsTheAmt.theAmt)
                return formatter.string(from: NSNumber(value: amount))
            default:
                let amount = Double(thisIsTheAmt.theAmt/100) + Double(thisIsTheAmt.theAmt%100)/100
                return formatter.string(from: NSNumber(value: amount))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.endEditing(true)
    }
    
}
