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
    static let shared = DeviceID()
    private init() {}
    
    func saveInDefaults(deviceID: String) {
        UserDefaults.standard.set(deviceID, forKey: DeviceKey.key)
        
        print("--==** Device ID from Model:  \(String(describing: deviceID))**==--")
    }
    
    func deleteInDefaults() {
        UserDefaults.standard.removeObject(forKey: DeviceKey.key)
    }
    
    func checkID() -> Bool? {
        return UserDefaults.standard.string(forKey: DeviceKey.key) != nil
    }
    
    func loadDeviceID() -> String? {
        return UserDefaults.standard.string(forKey: DeviceKey.key) ?? ""
    }
}
