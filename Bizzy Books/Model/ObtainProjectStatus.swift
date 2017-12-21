//
//  ObtainProjectStatus.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/20/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

class ObtainProjectStatus {
    
    //Get project status
    let projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
    var projectStatusName = ""
    var projectStatusId = -1
    
    func obtainStatus(universalItem: UniversalItem, completion: @escaping () -> ()) {
        if universalItem.projectItemKey == "0" {
            completion()
        } else {
            projectsRef.observe(.value) { (snapshot) in
                for item in snapshot.children {
                    let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                    if firebaseProject.key == universalItem.projectItemKey {
                        self.projectStatusId = firebaseProject.projectStatusId
                        self.projectStatusName = firebaseProject.projectStatusName
                        completion()
                    }
                }
            }
        }
    }
    
    
}
