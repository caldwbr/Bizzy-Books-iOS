//
//  WorkersCompItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct WorkersCompItem {
    
    let id: Int
    let type: String
    let ref: DatabaseReference?
    
    init(id: Int) {
        self.id = id
        switch id {
        case 0:
            self.type = "Sub Has WC"
        case 1:
            self.type = "Incurred WC"
        case 2:
            self.type = "WC N/A"
        default:
            self.type = "Sub Has WC"
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
