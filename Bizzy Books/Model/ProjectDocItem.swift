//
//  ProjectDocItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/11/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct ProjectDocItem {
    
    let key: String //By "key" is meant "id"
    let projectKey: String //What project is this document associated with?
    let typeId: Int //0 - Before Pic, 1 - During Pic, 2 - After Pic, 3 - Drawing, 4 - Calculations, 5 - Material List, 6 - Estimate, 7 - Contract, 8 - Labor Warranty, 9 - Material Warranty, 10 - Safety, 11 - Other
    let type: String
    let docUrl: String
    let ref: DatabaseReference?
    
    init(projectKey: String, typeId: Int, type: String, docUrl: String, key: String = "") {
        self.key = key
        self.projectKey = projectKey
        self.typeId = typeId
        self.type = type
        self.docUrl = docUrl
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        projectKey = snapshotValue["projectKey"] as! String
        typeId = snapshotValue["typeId"] as! Int
        type = snapshotValue["type"] as! String
        docUrl = snapshotValue["docUrl"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "projectKey": projectKey,
            "typeId": typeId,
            "type": type,
            "docUrl": docUrl
        ]
    }
    
}

