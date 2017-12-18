//
//  MultiversalItemViewModelController.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

class MultiversalItemViewModelController {
    
    var entitiesRef: DatabaseReference!
    fileprivate var multiversalItemViewModels: [MultiversalItemViewModel?] = []
    fileprivate var entities: [EntityItem?] = []
    
    
    
    func retrieveMultiversalItems(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        
        self.entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
    
        
        entitiesRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseEntity = EntityItem(snapshot: item as! DataSnapshot)
                self.entities.append(firebaseEntity)
            }
        }
    }
    
    var multiversalItemViewModelsCount: Int {
        return entities.count
        //return multiversalItemViewModels.count
    }
    
    func multiversalItemViewModel(at index: Int) -> EntityItem? {
        guard index >= 0 && index < multiversalItemViewModelsCount else { return nil }
        return entities[index]
    }
    
}
