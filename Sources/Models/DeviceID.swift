//
//  DeviceID.swift
//  I'm drinkin'
//
//  Created by astronauttux on 20.09.17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import Foundation


struct DeviceID {
    private let deviceID: String?
    
    init?(JSON: [String : AnyObject]) {
        guard let currentDeviceID = JSON["id"] as? String else { return }
        deviceID = currentDeviceID
    }
    
    func getDeviceID() -> String {
        return deviceID!
    }
}

