//
//  Atbash.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/11/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

extension String {
    func encrypt() -> String {
        var plain = Array(self)
        var cipher: String = ""
        if self.hasPrefix("¢®γⓟ☂") {
            return self
        } else {
            cipher = "¢®γⓟ☂"
            for i in 0..<plain.count {
                switch plain[i] {
                case "a":
                    plain[i] = "z"
                case "b":
                    plain[i] = "y"
                case "c":
                    plain[i] = "x"
                case "d":
                    plain[i] = "w"
                case "e":
                    plain[i] = "v"
                case "f":
                    plain[i] = "u"
                case "g":
                    plain[i] = "t"
                case "h":
                    plain[i] = "s"
                case "i":
                    plain[i] = "r"
                case "j":
                    plain[i] = "q"
                case "k":
                    plain[i] = "p"
                case "l":
                    plain[i] = "o"
                case "m":
                    plain[i] = "n"
                case "n":
                    plain[i] = "m"
                case "o":
                    plain[i] = "l"
                case "p":
                    plain[i] = "k"
                case "q":
                    plain[i] = "j"
                case "r":
                    plain[i] = "i"
                case "s":
                    plain[i] = "h"
                case "t":
                    plain[i] = "g"
                case "u":
                    plain[i] = "f"
                case "v":
                    plain[i] = "e"
                case "w":
                    plain[i] = "d"
                case "x":
                    plain[i] = "c"
                case "y":
                    plain[i] = "b"
                case "z":
                    plain[i] = "a"
                default:
                    print("Do not any thing")
                }
                cipher.append(plain[i])
            }
            return cipher
        }
    }
    
    mutating func decrypt() -> String {
        var plain: String = ""
        if self.hasPrefix("¢®γⓟ☂") {
            self = self.replacingOccurrences(of: "¢®γⓟ☂", with: "")
            var cipher = Array(self)
            for i in 0..<cipher.count {
                switch cipher[i] {
                case "a":
                    cipher[i] = "z"
                case "b":
                    cipher[i] = "y"
                case "c":
                    cipher[i] = "x"
                case "d":
                    cipher[i] = "w"
                case "e":
                    cipher[i] = "v"
                case "f":
                    cipher[i] = "u"
                case "g":
                    cipher[i] = "t"
                case "h":
                    cipher[i] = "s"
                case "i":
                    cipher[i] = "r"
                case "j":
                    cipher[i] = "q"
                case "k":
                    cipher[i] = "p"
                case "l":
                    cipher[i] = "o"
                case "m":
                    cipher[i] = "n"
                case "n":
                    cipher[i] = "m"
                case "o":
                    cipher[i] = "l"
                case "p":
                    cipher[i] = "k"
                case "q":
                    cipher[i] = "j"
                case "r":
                    cipher[i] = "i"
                case "s":
                    cipher[i] = "h"
                case "t":
                    cipher[i] = "g"
                case "u":
                    cipher[i] = "f"
                case "v":
                    cipher[i] = "e"
                case "w":
                    cipher[i] = "d"
                case "x":
                    cipher[i] = "c"
                case "y":
                    cipher[i] = "b"
                case "z":
                    cipher[i] = "a"
                default:
                    print("Do not any thing")
                }
                plain.append(cipher[i])
            }
            return plain
        } else {
            return self
        }
    }
}
