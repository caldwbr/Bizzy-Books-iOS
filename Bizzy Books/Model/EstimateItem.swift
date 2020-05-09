//
//  EstimateItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/31/20.
//  Copyright © 2020 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct EstimateItem {
    
    let key: String //By "key" is meant "id"
    let projectKey: String //By "projectKey" is meant "projectID"
    let title: String
    let description: String
    let unitPrice: Int
    let quantity: Int
    let totalPrice: Int
    let ref: DatabaseReference?
    
    init(projectKey: String, title: String, description: String, unitPrice: Int, quantity: Int, totalPrice: Int, key: String = "") {
        self.key = key
        self.projectKey = projectKey
        self.title = title
        self.description = description
        self.unitPrice = unitPrice
        self.quantity = quantity
        self.totalPrice = totalPrice
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        projectKey = (snapshotValue["projectKey"] as? String) ?? ""
        title = (snapshotValue["title"] as? String) ?? ""
        description = (snapshotValue["description"] as? String) ?? ""
        unitPrice = (snapshotValue["unitPrice"] as? Int) ?? 0
        quantity = snapshotValue["quantity"] as? Int ?? 0
        totalPrice = (snapshotValue["totalPrice"] as? Int) ?? 0
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "projectKey": projectKey,
            "title": title,
            "description": description,
            "unitPrice": unitPrice,
            "quantity": quantity,
            "totalPrice": totalPrice
        ]
    }
    
}
