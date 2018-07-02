/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppID {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if !isAppIdExist {
//            NetworkManager.sharedManager.post(nil, EndPoints.sharedInstance.createNewDeviceID(), nil, { [weak self] (response)  in
//                if let response = response as? BaseResponse {
//                    if let appID = response.deviceID {
//                        self?.save(appID: appID)
//                    }
//                }
//            })
        }

        return true
    }
}
