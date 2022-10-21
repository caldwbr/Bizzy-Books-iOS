//
//  EntityItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseUI

struct EntityItem: MultiversalItem {
    
    var multiversalType: Int = 2
    let key: String //By "key" is meant "id"
    let type: Int // I.e., relation ie customer, sub, employee, etc.
    let name: String
    let phoneNumber: String
    let email: String
    let street: String
    let city: String
    let state: String
    let ssn: String
    let ein: String
    let timeStamp: Any
    let ref: DatabaseReference?
    
    init(type: Int, name: String, phoneNumber: String, email: String, street: String, city: String, state: String, ssn: String, ein: String, timeStamp: Any, key: String = "") {
        self.key = key
        self.type = type
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.street = street
        self.city = city
        self.state = state
        self.ssn = ssn
        self.ein = ein
        self.timeStamp = timeStamp
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        type = snapshotValue["type"] as? Int ?? 0
        name = (snapshotValue["name"] as? String)?.decryptIt() ?? ""
        phoneNumber = (snapshotValue["phoneNumber"] as? String)?.decryptIt() ?? ""
        email = (snapshotValue["email"] as? String)?.decryptIt() ?? ""
        street = (snapshotValue["street"] as? String)?.decryptIt() ?? ""
        city = (snapshotValue["city"] as? String)?.decryptIt() ?? ""
        state = (snapshotValue["state"] as? String)?.decryptIt() ?? ""
        ssn = (snapshotValue["ssn"] as? String)?.decryptIt() ?? ""
        ein = (snapshotValue["ein"] as? String)?.decryptIt() ?? ""
        timeStamp = snapshotValue["timeStamp"] ?? 0
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any { //Turns an EntityItem into a dictionary for storage in Firebase
        return [
            "type": type,
            "name": name,
            "phoneNumber": phoneNumber,
            "email": email,
            "street": street,
            "city": city,
            "state": state,
            "ssn": ssn,
            "ein": ein,
            "timeStamp": timeStamp
        ]
    }
    
}
