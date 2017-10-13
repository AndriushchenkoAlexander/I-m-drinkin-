/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import Appodeal


class AdsManager {
    static let sharedManager = AdsManager()

    func initAdsManager() {
        initializeAppodealSDK()
        configureAppearance()
    }
    
    func setBannerAndShowAD(setViewController: UIViewController) {
        Appodeal.setBannerDelegate(setViewController as! AppodealBannerDelegate)
        Appodeal.showAd(AppodealShowStyle.bannerTop, rootViewController: setViewController)
    }
    
    private func initializeAppodealSDK() {
        let adTypes: AppodealAdType = [.banner]
        Appodeal.setLogLevel(.off)
        Appodeal.setAutocache(true, types: adTypes)
        Appodeal.initialize(withApiKey: "", types: adTypes)
    }
    
    private func configureAppearance() {
        let navBarAttributes = [NSAttributedStringKey.foregroundColor: UIColor.clear]
        
        UINavigationBar.appearance().tintColor = .white
        
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarAttributes, for: .highlighted)
        
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = .lightGray
        }
        UITabBar.appearance().tintColor = .white
    }
}
