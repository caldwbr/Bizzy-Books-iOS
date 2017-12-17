//
//  MultiversalItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/14/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation

protocol MultiversalItem {
    var multiversalType: Int { get set } // 0 = Universal, 1 = Project, 2 = Entity, 3 = Account, 4 = Vehicle
}
