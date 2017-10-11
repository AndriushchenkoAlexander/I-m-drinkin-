/*
 DeviceID.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation

struct DeviceKey {
    static let key = "deviceID"
}

struct DeviceID {
    init?(JSON: [String : AnyObject]) {
        if let deviceID = JSON["id"] as? String {
            UserDefaults.standard.set(deviceID, forKey: DeviceKey.key)
        }
    }
    
    static func checkID() -> Bool {
        if UserDefaults.standard.string(forKey: DeviceKey.key) != nil {
            return true
        }
        return false
    }
    
    static func getDeviceID() -> String {
        if let deviceID = UserDefaults.standard.string(forKey: DeviceKey.key) {
            return deviceID
        }
        return ""
    }
}

