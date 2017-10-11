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

        LocationsManager.locationProvideAPIKey()
        
//        let adsManager = AdsManager()
//        adsManager.initializeAdsManager()
        
        if DeviceID.checkID() == false {
            NetworkManager.sharedManager.post(<#T##target: UIViewController?##UIViewController?#>, <#T##endpoint: endPoints##endPoints#>, <#T##parameters: [String : String]?##[String : String]?#>)
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

