//
//  AdvertisingMeansItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct AdvertisingMeansItem {
    
    let id: Int
    let type: String
    let ref: DatabaseReference?
    
    init(id: Int) {
        self.id = id
        switch id {
        case 0:
            self.type = "Referral"
        case 1:
            self.type = "Website"
        case 2:
            self.type = "YP"
        case 3:
            self.type = "Social Media"
        case 4:
            self.type = "Soliciting"
        case 5:
            self.type = "Google Adwords"
        case 6:
            self.type = "Company Shirts"
        case 7:
            self.type = "Sign"
        case 8:
            self.type = "Vehicle Wrap"
        case 9:
            self.type = "Billboard"
        case 10:
            self.type = "TV"
        case 11:
            self.type = "Radio"
        case 12:
            self.type = "Other"
        default:
            self.type = "Referral"
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
