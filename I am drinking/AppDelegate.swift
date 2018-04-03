/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LocationsManager.sharedManager.locationProvideAPIKey()
        
        if DeviceID.shared.checkID() == false {
            NetworkManager.sharedManager.post(nil, EndPoints.sharedInstance.createNewDeviceID(), nil, { (response)  in
                if let response = response as? BaseResponse {
                    if let deviceID = response.deviceID {
                        print("--==** AppDelegate - NEW Device ID :  \n\(deviceID) \n**==--")
                        DeviceID.shared.saveInDefaults(deviceID: deviceID)
                    }
                }
            })
        }
        return true
    }
}

