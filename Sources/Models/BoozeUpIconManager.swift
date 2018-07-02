/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit

enum BoozeUpIconManager: String {
    // Data about what icon show is obtained from the server
    case Beer = "1"
    case Wine = "2"
    case Cola = "3"
    case Juice = "4"
    case Whiskey = "5"
    case Vodka = "6"
    case Coffee = "7"
    case Coctail = "8"
    
    init(rawValue: String) {
        switch rawValue {
        case "1": self = .Beer
        case "2": self = .Wine
        case "3": self = .Cola
        case "4": self = .Juice
        case "5": self = .Whiskey
        case "6": self = .Vodka
        case "7": self = .Coffee
        case "8": self = .Coctail
        default: self = .Juice
        }
    }
}


// Property through extension which will default to assign the value to the icon:
extension BoozeUpIconManager {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
