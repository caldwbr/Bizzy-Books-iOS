//
//  SearchItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/1/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import Foundation

struct SearchItem {
    let i: Int // If positive, the number correlates to MIP number; if negative, it correlates to a specific "goody"
    let name: String // What the user sees which makes sense to him
    
    init(i: Int, name: String) {
        self.i = i
        self.name = name
    }
}
