//
//  Extensions.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/18/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import RNCryptor

extension String {
    
    func encryptIt() -> String {
        let data = self.data(using: .utf8)
        let ciphertext = RNCryptor.encrypt(data: data!, withPassword: "82gw2yN7bK33jVma1John419")
        return ciphertext.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
    }
    
    func decryptIt() -> String {
        do {
            let data = Data.init(base64Encoded: self)
            let originalData = try RNCryptor.decrypt(data: data!, withPassword: "82gw2yN7bK33jVma1John419")
            let base64EncodedData = originalData.base64EncodedData()
            //Decode base64
            let newData = NSData(base64Encoded: base64EncodedData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)! //BOTH this line and the one above ACTUALLY ARE necessary BION! (believe it or not)
            let newNSString = NSString(data: newData as Data, encoding: String.Encoding.utf8.rawValue)!
            return newNSString as String
        } catch {
            print(error)
            return ""
        }
    }
}
