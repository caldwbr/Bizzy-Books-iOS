//
//  UniversalItemType.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct UniversalItemType {
    
    let id: Int
    let type: String
    let ref: DatabaseReference?
    
    init(id: Int) {
        self.id = id
        switch id {
        case 0:
            self.type = "Business"
        case 1:
            self.type = "Personal"
        case 2:
            self.type = "Mixed"
        case 3:
            self.type = "Fuel"
        case 4:
            self.type = "Transfer"
        case 5:
            self.type = "Adjust"
        case 6:
            self.type = "Documents"
        default:
            self.type = "Business"
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
