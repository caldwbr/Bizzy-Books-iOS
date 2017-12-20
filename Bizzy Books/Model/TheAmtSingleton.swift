//
//  TheAmtSingleton.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/18/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//
import UIKit

final class TheAmtSingleton {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = TheAmtSingleton()
    
    // MARK: Local Variable
    
    var theAmt: Int = Int()
    var howMany: Int = Int()
    
}
