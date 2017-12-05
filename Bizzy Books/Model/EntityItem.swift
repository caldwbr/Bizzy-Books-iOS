//
//  EntityItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct EntityItem {
    
    let key: String //By "key" is meant "id"
    let type: Int
    let name: String
    let phoneNumber: String
    let email: String
    let street: String
    let city: String
    let state: String
    let ssn: String
    let ein: String
    let ref: DatabaseReference?
    
    init(type: Int, name: String, phoneNumber: String, email: String, street: String, city: String, state: String, ssn: String, ein: String, key: String = "") {
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
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        type = snapshotValue["type"] as! Int
        name = snapshotValue["name"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        email = snapshotValue["email"] as! String
        street = snapshotValue["street"] as! String
        city = snapshotValue["city"] as! String
        state = snapshotValue["state"] as! String
        ssn = snapshotValue["ssn"] as! String
        ein = snapshotValue["ein"] as! String
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
            "ein": ein
        ]
    }
    
}