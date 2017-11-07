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
    init?(json: JSON) {
        if let deviceID = json["id"] as? String {
            UserDefaults.standard.set(deviceID, forKey: DeviceKey.key)
            print("--==** Device ID from Model:  \(String(describing: deviceID))**==--")
        }
    }
    
    static func checkID() -> Bool? {
        if UserDefaults.standard.string(forKey: DeviceKey.key) != nil {
            return true
        }
        return false
    }
    
    static func getDeviceID() -> String? {
        if let deviceID = UserDefaults.standard.string(forKey: DeviceKey.key) {
            return deviceID
        }
        return ""
    }
}

/*
 func saveDeviceID(json: Any?) {
 guard let _ = DeviceID.init(json: json as! JSON) else { return }
 }
 */
