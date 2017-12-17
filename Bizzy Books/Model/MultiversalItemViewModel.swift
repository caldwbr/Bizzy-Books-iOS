//
//  MultiversalItemViewModel.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation

struct MultiversalItemViewModel {
    
    let key: String //By "key" is meant "id"
    let type: Int
    let name: String
    let phoneNumber: String
    let email: String
    let street: String
    let city: String
    let state: String
    let ssn: String
    let ein: String
    
    init(entityItem: EntityItem) {
        key = entityItem.key
        type = entityItem.type
        name = entityItem.name
        phoneNumber = entityItem.phoneNumber
        email = entityItem.email
        street = entityItem.street
        city = entityItem.city
        state = entityItem.state
        ssn = entityItem.ssn
        ein = entityItem.ein
    }
    
}
