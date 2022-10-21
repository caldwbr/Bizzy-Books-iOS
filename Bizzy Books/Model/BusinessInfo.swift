//
//  BusinessInfo.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/20/19.
//  Copyright © 2019 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseUI

struct BusinessInfo {
    var businessName: String
    var businessAddress1: String
    var businessAddress2: String
    var mainWork: String
    var subcat1: String
    var subcat2: String
    var subcat3: String
    var subcat4: String
    var subcat5: String
    var subcat6: String
    let key: String
    var ref: DatabaseReference!
    
    init(businessName: String, businessAddress1: String, businessAddress2: String, mainWork: String, subcat1: String, subcat2: String, subcat3: String, subcat4: String, subcat5: String, subcat6: String, key: String = "") {
        self.businessName = businessName
        self.businessAddress1 = businessAddress1
        self.businessAddress2 = businessAddress2
        self.mainWork = mainWork
        self.subcat1 = subcat1
        self.subcat2 = subcat2
        self.subcat3 = subcat3
        self.subcat4 = subcat4
        self.subcat5 = subcat5
        self.subcat6 = subcat6
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: AnyObject] {
            businessName = snapshotValue["businessName"] as? String ?? ""
            businessAddress1 = snapshotValue["businessAddress1"] as? String ?? ""
            businessAddress2 = snapshotValue["businessAddress2"] as? String ?? ""
            mainWork = snapshotValue["mainWork"] as? String ?? ""
            subcat1 = snapshotValue["subcat1"] as? String ?? ""
            subcat2 = snapshotValue["subcat2"] as? String ?? ""
            subcat3 = snapshotValue["subcat3"] as? String ?? ""
            subcat4 = snapshotValue["subcat4"] as? String ?? ""
            subcat5 = snapshotValue["subcat5"] as? String ?? ""
            subcat6 = snapshotValue["subcat6"] as? String ?? ""
            ref = snapshot.ref
            key = snapshot.key
        } else {
            businessName = ""
            businessAddress1 = ""
            businessAddress2 = ""
            mainWork = ""
            subcat1 = ""
            subcat2 = ""
            subcat3 = ""
            subcat4 = ""
            subcat5 = ""
            subcat6 = ""
            key = ""
            ref = nil
        }
        
    }
    
    func toAnyObject() -> Any {
        return [
            "businessName": businessName,
            "businessAddress1": businessAddress1,
            "businessAddress2": businessAddress2,
            "mainWork": mainWork,
            "subcat1": subcat1,
            "subcat2": subcat2,
            "subcat3": subcat3,
            "subcat4": subcat4,
            "subcat5": subcat5,
            "subcat6": subcat6
        ]
    }
}


