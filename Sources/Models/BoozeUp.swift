//
//  BoozeUp.swift
//  I am drinking
//
//  Created by astronauttux on 11.10.17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import Foundation


struct BoozeUP {
    let latitude: String?
    let longitude: String?
    let drink: Int?
    
    init?(JSON: [String : AnyObject]) {
        latitude = JSON["id"] as? String
    }
}
