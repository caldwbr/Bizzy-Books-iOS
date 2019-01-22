//
//  Extensions.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/18/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import RNCryptor

private let hmacKey = "1John419aa84526882gw2yN7bK33jVma".data(using: .utf8)

extension Int {
    func toString() -> String {
        return String("\(self)")
    }
}

extension Int {
    func sCur() -> String { //Stringify via currency output using int number of pennies
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let amount = Double(self/100) + Double(self%100)/100
        return formatter.string(from: NSNumber(value: amount))!
        
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.15f", self)
    }
}

extension Double {
    func sPor() -> String { //Stringify via percent output using double percent expressed first as say 0.34
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .percent
        return formatter.string(from: NSNumber(value: self))!
    }
}

extension String {
    
    func toInt() -> Int {
        return Int(self)!
    }
    
    func toDouble() -> Double {
        return Double(self)!
    }
    
    func encryptIt() -> String {
        //let data = self.data(using: .utf8)
        //let encryptor = RNCryptor.EncryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
        //let ciphertext = encryptor.encrypt(data: data!)
        //return ciphertext.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
        return self
    }
    
    func decryptIt() -> String {
        /*do {
            let data = Data.init(base64Encoded: self)
            let decryptor = RNCryptor.DecryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
            let originalData = try decryptor.decrypt(data: data!)
            let base64EncodedData = originalData.base64EncodedData()
            let newData = NSData(base64Encoded: base64EncodedData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            let newNSString = NSString(data: newData as Data, encoding: String.Encoding.utf8.rawValue)!
            return newNSString as String
        } catch {
            return self
        }*/
        return self
    }
    
}

extension Data {
    
    func encryptIt() -> Data {
        //let encryptor = RNCryptor.EncryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
        //return encryptor.encrypt(data: self as Data)
        return self
    }
    
    func decryptIt() -> Data {
        /*
        do {
            let decryptor = RNCryptor.DecryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
            let originalData = try decryptor.decrypt(data: self)
            return originalData
        } catch {
            return self
        }
 */
        return self
        
    }
    
    func pixelCrypt(isEncrypted: Bool) -> Data {
        //return isEncrypted ? self.decryptIt() : self.encryptIt()
        return self
    }
    
}

extension UIImage {
    
    func oneTenthIt() -> Data {
        let data = UIImageJPEGRepresentation(self, 0.1)
        return data!
    }
    
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
