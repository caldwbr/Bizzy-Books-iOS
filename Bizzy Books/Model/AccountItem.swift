//
//  AccountItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct AccountItem {
    
    let key: String
    let name: String
    let phoneNumber: String
    let email: String
    let street: String
    let city: String
    let state: String
    let startingBal: Int
    let ref: DatabaseReference?
    
    init(name: String, phoneNumber: String, email: String, street: String, city: String, state: String, startingBal: Int, key: String = "") {
        self.key = key
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.street = street
        self.city = city
        self.state = state
        self.startingBal = startingBal
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        email = snapshotValue["email"] as! String
        street = snapshotValue["street"] as! String
        city = snapshotValue["city"] as! String
        state = snapshotValue["state"] as! String
        startingBal = snapshotValue["startingBal"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "phoneNumber": phoneNumber,
            "email": email,
            "street": street,
            "city": city,
            "state": state,
            "startingBal": startingBal
        ]
    }
    
}
