//
//  TaxReasonItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct TaxReasonItem {
    
    let id: Int
    let type: String
    let ref: DatabaseReference?
    
    init(id: Int) {
        self.id = id
        switch id {
        case 0:
            self.type = "Income"
        case 1:
            self.type = "Supplies"
        case 2:
            self.type = "Labor"
        case 3:
            self.type = "Meals"
        case 4:
            self.type = "Office"
        case 5:
            self.type = "Vehicle"
        case 6:
            self.type = "Advertising"
        case 7:
            self.type = "Pro Help"
        case 8:
            self.type = "Rent Machine"
        case 9:
            self.type = "Rent Property"
        case 10:
            self.type = "Tax+License"
        case 11:
            self.type = "Insurance(WC+GL)"
        case 12:
            self.type = "Travel"
        case 13:
            self.type = "Employee Benefit"
        case 14:
            self.type = "Depreciation"
        case 15:
            self.type = "Depletion"
        case 16:
            self.type = "Utilities"
        case 17:
            self.type = "Commissions"
        case 18:
            self.type = "Wages"
        case 19:
            self.type = "Mortgage Interest"
        case 20:
            self.type = "Other Interest"
        case 21:
            self.type = "Pension"
        case 22:
            self.type = "Repairs"
        default:
            self.type = "Supplies"
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
