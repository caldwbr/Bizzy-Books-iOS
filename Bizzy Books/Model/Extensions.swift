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

extension Double {
    func toString() -> String {
        return String(format: "%.15f", self)
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
        let data = self.data(using: .utf8)
        let encryptor = RNCryptor.EncryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
        let ciphertext = encryptor.encrypt(data: data!)
        return ciphertext.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
    }
    
    func decryptIt() -> String {
        do {
            let data = Data.init(base64Encoded: self)
            let decryptor = RNCryptor.DecryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
            let originalData = try decryptor.decrypt(data: data!)
            let base64EncodedData = originalData.base64EncodedData()
            let newData = NSData(base64Encoded: base64EncodedData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            let newNSString = NSString(data: newData as Data, encoding: String.Encoding.utf8.rawValue)!
            return newNSString as String
        } catch {
            return self
        }
    }
    
}

extension Data {
    
    func encryptIt() -> Data {
        let encryptor = RNCryptor.EncryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
        return encryptor.encrypt(data: self as Data)
    }
    
    func decryptIt() -> Data {
        do {
            let decryptor = RNCryptor.DecryptorV3(encryptionKey: MIProcessor.sharedMIP.askForTheKey(), hmacKey: hmacKey!)
            let originalData = try decryptor.decrypt(data: self)
            return originalData
        } catch {
            return self
        }
        
    }
    
    func pixelCrypt(isEncrypted: Bool) -> Data {
        return isEncrypted ? self.decryptIt() : self.encryptIt()
    }
    
}

extension UIImage {
    
    func oneTenthIt() -> Data {
        let data = UIImageJPEGRepresentation(self, 0.1)
        return data!
    }
    
}
