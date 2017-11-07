/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LocationsManager.sharedManager.locationProvideAPIKey()

        
        if DeviceID.checkID() == false {
            NetworkManager.sharedManager.post(.device, nil, <#Parameters?#>, <#(ResponseData?) -> ()#>)
        }
        print("--==** AppDelegate Device ID:  \(String(describing: DeviceID.getDeviceID()))**==--")
        
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

