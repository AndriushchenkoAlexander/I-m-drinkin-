/*
 DeviceID.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation

private let key = "deviceID"

protocol AppID {}

extension AppID {
    var isAppIdExist: Bool {
        return UserDefaults.standard.string(forKey: key) != nil
    }
    
    func save(appID: String) {
        UserDefaults.standard.set(appID, forKey: key)
        print("--==** AppID - NEW Device ID : \n\(appID) \n**==--")
    }
    
    func deleteAppID() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func loadAppID() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    /// Object ID generator
    ///
    /// - Returns: new uniq Int64 id
    func generateNewObjectId() -> Int64 {
        return Int64(UUID().hashValue) * Int64(UUID().hashValue)
    }
}
