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
    var projectStatusName = ""
    var projectStatusId = -1
    
    func obtainStatus(universalItem: inout UniversalItem, completion: @escaping () -> ()) {
        if universalItem.projectItemKey == "0" {
            completion()
        } else {
            for projectItem in MIProcessor.sharedMIP.mIPProjects {
                if projectItem.key == universalItem.projectItemKey {
                    universalItem.projectStatusId = projectItem.projectStatusId
                    universalItem.projectStatusString = projectItem.projectStatusName
                    completion()
                }
            }
        }
    }
    
    
}
