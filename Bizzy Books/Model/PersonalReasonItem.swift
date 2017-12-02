//
//  PersonalReasonItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct PersonalReasonItem {
    
    let id: Int
    let type: String
    let ref: DatabaseReference?
    
    init(id: Int) {
        self.id = id
        switch id {
        case 0:
            self.type = "Food"
        case 1:
            self.type = "Fun"
        case 2:
            self.type = "Pet"
        case 3:
            self.type = "Utilities"
        case 4:
            self.type = "Phone"
        case 5:
            self.type = "Office"
        case 6:
            self.type = "Giving"
        case 7:
            self.type = "Insurance"
        case 8:
            self.type = "House"
        case 9:
            self.type = "Yard"
        case 10:
            self.type = "Medical"
        case 11:
            self.type = "Travel"
        case 12:
            self.type = "Other"
        default:
            self.type = "Food"
        }
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! Int
        type = snapshotValue["type"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "type": type
        ]
    }
    
}
