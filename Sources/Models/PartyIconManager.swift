/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit


enum PartyIconManager: String {
    // Data about what icon show is obtained from the server
    case Beer = "Beer"
    case Wine = "Wine"
    case Cola = "Cola"
    case Juice = "Juice"
    case Whiskey = "Whiskey"
    //   case UnpredictedIcon = "unpredicted-icon" // A certain case for any value that does not coincide with all the others
    
    init(rawValue: String) {
        switch rawValue {
        case "Beer": self = .Beer
        case "Wine": self = .Wine
        case "Cola": self = .Cola
        case "Juice": self = .Juice
        case "Whiskey": self = .Whiskey
        default: self = .Juice
        }
    }
}

// Property through extension which will default to assign the value to the icon:
extension PartyIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
