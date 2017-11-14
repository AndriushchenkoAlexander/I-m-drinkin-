/*
 DeviceID.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation
import ObjectMapper

struct DeviceKey {
    static let key = "deviceID"
    static let created = "createdID"
    static let updated = "updatedID"
    static let deviceURL = "updatedID"
}


class DeviceID: Mappable {
    var deviceID: String?
    var created: String?
    var updated: String?
    var deviceIdUrl: String?
    
    required convenience init?(map: Map) {
        self.init()
        self.saveInDefaults()
    }
    
    func mapping(map: Map) {
        deviceID      <- map["id"]
        created       <- map["created"]
        updated       <- map["updated"]
        deviceIdUrl   <- map["url"]
    }
}


extension DeviceID {
    func saveInDefaults() {
        UserDefaults.standard.set(deviceID, forKey: DeviceKey.key)
        UserDefaults.standard.set(created, forKey: DeviceKey.created)
        UserDefaults.standard.set(updated, forKey: DeviceKey.updated)
        
        print("--==** Device ID from Model:  \(String(describing: deviceID))**==--")
        print("--==** Created ID from Model:  \(String(describing: created))**==--")
        print("--==** Updated ID from Model:  \(String(describing: updated))**==--")
    }
    
    func deleteInDefaults() {
        UserDefaults.standard.removeObject(forKey: DeviceKey.key)
        UserDefaults.standard.removeObject(forKey: DeviceKey.created)
        UserDefaults.standard.removeObject(forKey: DeviceKey.updated)
    }
    
    func checkID() -> Bool? {
        if UserDefaults.standard.string(forKey: DeviceKey.key) != nil {
            return true
        }
        return false
    }
    
    func getDeviceID() -> String? {
        if let deviceID = UserDefaults.standard.string(forKey: DeviceKey.key) {
            return deviceID
        }
        return ""
    }
}
