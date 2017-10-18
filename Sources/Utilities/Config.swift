//
//  Config.swift
//  I am drinking
//
//  Created by astronauttux on 18.10.17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import Foundation


class Config {
    static func stringToDouble(string: String?) -> Double {
        var newValue = 0.0
        
        if let lat = string {
            newValue = Double(lat) ?? 0.0
        }
        return newValue
    }
}
