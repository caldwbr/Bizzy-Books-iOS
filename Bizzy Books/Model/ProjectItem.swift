//
//  ProjectItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct ProjectItem: MultiversalItem {
    
    var multiversalType: Int = 1
    let key: String //By "key" is meant "id," but to Firebase it means something chronologically too
    let name: String
    let customerName: String
    let customerKey: String
    let howDidTheyHearOfYouString: String
    let howDidTheyHearOfYouId: Int
    let projectTags: String
    let projectAddressStreet: String
    let projectAddressCity: String
    let projectAddressState: String
    let projectNotes: String
    //let projectDocItems: [ProjectDocItem]?
    let projectStatusName: String
    let projectStatusId: Int //0 - Job lead, 1 - Bid, 2 - Contract, 3 - Paid, 4 - Lost, 5 - Other
    let timeStamp: Any
    let ref: DatabaseReference?
    
    init(name: String, customerName: String, customerKey: String, howDidTheyHearOfYouString: String, howDidTheyHearOfYouId: Int, projectTags: String, projectAddressStreet: String, projectAddressCity: String, projectAddressState: String, projectNotes: String, projectStatusName: String, projectStatusId: Int, timeStamp: Any, key: String = "") {
        self.key = key
        self.name = name
        self.customerName = customerName
        self.customerKey = customerKey
        self.howDidTheyHearOfYouString = howDidTheyHearOfYouString
        self.howDidTheyHearOfYouId = howDidTheyHearOfYouId
        self.projectTags = projectTags
        self.projectAddressStreet = projectAddressStreet
        self.projectAddressCity = projectAddressCity
        self.projectAddressState = projectAddressState
        self.projectNotes = projectNotes
        self.projectStatusName = projectStatusName
        self.projectStatusId = projectStatusId
        self.timeStamp = timeStamp
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as? String ?? ""
        customerName = snapshotValue["customerName"] as? String ?? ""
        customerKey = snapshotValue["customerKey"] as? String ?? ""
        howDidTheyHearOfYouString = snapshotValue["howDidTheyHearOfYouString"] as? String ?? ""
        howDidTheyHearOfYouId = snapshotValue["howDidTheyHearOfYouId"] as? Int ?? 0
        projectTags = snapshotValue["projectTags"] as? String ?? ""
        projectAddressStreet = snapshotValue["projectAddressStreet"] as? String ?? ""
        projectAddressCity = snapshotValue["projectAddressCity"] as? String ?? ""
        projectAddressState = snapshotValue["projectAddressState"] as? String ?? ""
        projectNotes = snapshotValue["projectNotes"] as? String ?? ""
        projectStatusName = snapshotValue["projectStatusName"] as? String ?? ""
        projectStatusId = snapshotValue["projectStatusId"] as? Int ?? 0
        timeStamp = snapshotValue["timeStamp"] ?? 0
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "customerName": customerName,
            "customerKey": customerKey,
            "howDidTheyHearOfYouString": howDidTheyHearOfYouString,
            "howDidTheyHearOfYouId": howDidTheyHearOfYouId,
            "projectTags": projectTags,
            "projectAddressStreet": projectAddressStreet,
            "projectAddressCity": projectAddressCity,
            "projectAddressState": projectAddressState,
            "projectNotes": projectNotes,
            "projectStatusName": projectStatusName,
            "projectStatusId": projectStatusId,
            "timeStamp": timeStamp
        ]
    }
}
