//
//  BoozeUp.swift
//  I am drinking
//
//  Created by astronauttux on 11.10.17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import Foundation


struct BoozeUp {
    let device: String?
    let latitude: String?
    let longitude: String?
    let drink: Int?
    
    init?(json: JSON) {
        device = json["device"] as? String
        latitude = json["latitude"] as? String
        longitude = json["longitude"] as? String
        drink = json["drink"] as? Int
    }
}
