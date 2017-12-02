//
//  FuelTypeItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct FuelTypeItem {
    
    let id: Int
    let type: String
    let ref: DatabaseReference?
    
    init(id: Int) {
        self.id = id
        switch id {
        case 0:
            self.type = "87 Gas"
        case 1:
            self.type = "89 Gas"
        case 2:
            self.type = "91 Gas"
        case 3:
            self.type = "Diesel"
        default:
            self.type = "87 Gas"
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
