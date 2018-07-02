/*
 Booze.swift
 I am drinking
 
 Created by astronauttux on 11.10.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation

class Booze: Codable {
    var boozeUpID: String?
    var device: String?
    var latitude: String?
    var longitude: String?
    var drink: Int?
    var txtDrink: String?
    var description: String?
//    
//    required convenience init?(map: Map) { self.init() }
//    
//    func mapping(map: Map) {
//        boozeUpID   <- map["id"]
//        device      <- map["device"]
//        latitude    <- map["latitude"]
//        longitude   <- map["longitude"]
//        drink       <- map["drink"]
//        txtDrink    <- map["human_readable_drink"]
//        description <- map["description"]
//    }
}
