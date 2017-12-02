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
    
    var amt: Int = 0
    let formatter = NumberFormatter()
    var numberKind = Int()
    
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
            if let digit = Int(string) {
                
                if amt > 10_000_000_00 {
                    amt = 0
                    self.text = ""
                    return false
                }
                amt = amt * 10 + digit
                self.text = updateAmount()
            }
            if string == "" {
                amt = amt/10
                self.text = amt == 0 ? "" : updateAmount()
            }
            return false //This was the line that, when set to true, was appending the digit-in-purgatory after field had already been rendered by "updateAmount()" IE $0.055
        }
        return false
    }
    
    func updateAmount() -> String? {
        switch numberKind {
        case 0:
            let amount = Double(amt/100) + Double(amt%100)/100
            return formatter.string(from: NSNumber(value: amount))
        case 1:
            let amount = Double(amt/1000) + Double(amt%1000)/1000
            return formatter.string(from: NSNumber(value: amount))
        case 2:
            let amount = Double(amt)
            return formatter.string(from: NSNumber(value: amount))
        default:
            let amount = Double(amt/100) + Double(amt%100)/100
            return formatter.string(from: NSNumber(value: amount))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.endEditing(true)
    }
    
}
