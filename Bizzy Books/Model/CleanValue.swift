//
//  CleanValue.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/30/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
