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
        
        let device = DeviceID()
        if device.checkID() == false {
            NetworkManager.sharedManager.post(nil, EndPoints.sharedInstance.createNewDeviceID(), nil, { (response)  in
                if let deviceID = Mapper<DeviceID>().map(JSONObject: response) {
                    print("--==** AppDelegate - NEW Device ID:  \(deviceID.getDeviceID() ?? "ID is absent")**==--")
                    deviceID.saveInDefaults()
                }
            })
        }
        return true
    }
    /*
     func applicationWillResignActive(_ application: UIApplication) {
     
     }
     
     func applicationDidEnterBackground(_ application: UIApplication) {
     
     }
     
     func applicationWillEnterForeground(_ application: UIApplication) {
     
     }
     
     func applicationDidBecomeActive(_ application: UIApplication) {
     
     }
     
     func applicationWillTerminate(_ application: UIApplication) {
     
     }
     */
}

