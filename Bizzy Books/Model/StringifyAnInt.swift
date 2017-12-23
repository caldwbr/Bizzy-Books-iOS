//
//  StringifyAnInt.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/17/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
class StringifyAnInt {
    
    let formatter = NumberFormatter()
    
    func stringify(theInt: Int) -> String {
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let amount = Double(theInt/100) + Double(theInt%100)/100
        return formatter.string(from: NSNumber(value: amount))!
    }
    
    func stringify(theInt: Int, theNumberStyle: NumberFormatter.Style, theGroupingSeparator: Bool) -> String {
        switch theNumberStyle {
        case .currency:
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            let amount = Double(theInt/100) + Double(theInt%100)/100
            return formatter.string(from: NSNumber(value: amount))!
        case .decimal:
            formatter.usesGroupingSeparator = theGroupingSeparator
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            switch theGroupingSeparator {
            case true: // I.e., number of gallons of fuel
                let amount = Double(theInt/1000) + Double(theInt%1000)/1000
                return formatter.string(from: NSNumber(value: amount))!
            default: // I.e., odometer
                let amount = Double(theInt)
                return formatter.string(from: NSNumber(value: amount))!
            }
        case .none:
            formatter.usesGroupingSeparator = theGroupingSeparator
            formatter.numberStyle = .none
            return formatter.string(from: NSNumber(value: theInt))!
        default:
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            let amount = Double(theInt/100) + Double(theInt%100)/100
            return formatter.string(from: NSNumber(value: amount))!
        }
    }
    
}
