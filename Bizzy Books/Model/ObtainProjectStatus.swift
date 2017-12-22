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
    
    func obtainStatus(i: Int) {
        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
        } else {
            for projectItem in MIProcessor.sharedMIP.mIPProjects {
                if projectItem.key == MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey {
                    MIProcessor.sharedMIP.mIPUniversals[i].projectStatusId = projectItem.projectStatusId
                    MIProcessor.sharedMIP.mIPUniversals[i].projectStatusString = projectItem.projectStatusName
                }
            }
        }
    }
}
