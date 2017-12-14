//
//  Config.swift
//  I am drinking
//
//  Created by astronauttux on 18.10.17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import UIKit
import CFNotify

final class Configuration {
    static let sharedInstance = Configuration()
    private init() { CFNotify.delegate = self as? CFNotifyDelegate }
    
    // MARK: -
    // MARK: Convert String to Double
    
    func stringToDouble(string: String?) -> Double {
        var newValue = 0.0
        
        if let lat = string {
            newValue = Double(lat) ?? 0.0
        }
        return newValue
    }
    
    func stringCoordinates(double: Double) -> String {
        return String(format: "%.7f", double)
    }
}

// MARK: -
// MARK: Show Alert View

extension Configuration {
    func showNotifyView(_ target: UIViewController,
                        _ title: String,
                        _ message: String,
                        _ completion: @escaping () -> Void) {
        
        let customCyberView = CFNotifyView.cyberWith(title: title,
                                                     titleFont: .boldSystemFont(ofSize: 18),
                                                     titleColor: UIColor(red:0.02, green:0.13, blue:0.14, alpha:1.0),
                                                     body: message,
                                                     bodyFont: .boldSystemFont(ofSize: 16),
                                                     bodyColor: UIColor(red:0.07, green:0.32, blue:0.61, alpha:1.0),
                                                     image: nil,
                                                     backgroundColor: UIColor(red:0.47, green:0.78, blue:0.83, alpha:1.0),
                                                     blurStyle: UIBlurEffectStyle.dark)
        
        var cyberViewConfig = CFNotify.Config()
        cyberViewConfig.initPosition = .top(.random)
        cyberViewConfig.appearPosition = .center
        cyberViewConfig.hideTime = .custom(seconds: 3)
        
        CFNotify.present(config: cyberViewConfig, view: customCyberView)
    }
}
