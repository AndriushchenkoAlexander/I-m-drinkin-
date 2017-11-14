/*
 BoozeUp.swift
 I am drinking
 
 Created by astronauttux on 11.10.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation
import ObjectMapper

class BoozeUp: Mappable {
    var device: String?
    var latitude: String?
    var longitude: String?
    var drink: Int?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        device      <- map["device"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
        drink       <- map["drink"]
    }
}
