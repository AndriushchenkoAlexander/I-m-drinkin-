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
        case "Beer": self = .Beer
        case "Wine": self = .Wine
        case "Cola": self = .Cola
        case "Juice": self = .Juice
        case "Whiskey": self = .Whiskey
        case "Vodka": self = .Vodka
        case "Coffee": self = .Coffee
        case "Coctail": self = .Coctail
        default: self = .Juice
        }
    }
}


// Property through extension which will default to assign the value to the icon:
extension BoozeUpIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
