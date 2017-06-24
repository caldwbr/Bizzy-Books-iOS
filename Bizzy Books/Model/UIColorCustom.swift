//
//  UIColorCustom.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/24/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct BizzyColor {
        struct Blue {
            static let Project = UIColor(netHex: 0x2196F3) //Primary
            static let Who = UIColor(netHex: 0x1976D2) //Darker Primary
        }
        struct Yellow {
            static let TheFabButton = UIColor(netHex: 0xFFD740) //Accent
        }
        struct Green {
            static let What = UIColor(netHex: 0x388E3C)
        }
        struct Grey {
            static let Notes = UIColor(netHex: 0xA3A3A3)
        }
        struct Purple {
            static let Whom = UIColor(netHex: 0x311B92)
        }
        struct Magenta {
            static let Reason = UIColor(netHex: 0x880E4F)
        }
        struct Orange {
            static let WC = UIColor(netHex: 0xF57C00)
        }
    }
}
