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
        return Double(string ?? "") ?? 0.0
    }
    
    func stringCoordinates(double: Double) -> String {
        return String(format: "%.7f", double)
    }
    
    struct CoachMarkText {
        static let checkInButtonText = "Нажмите, что бы отобразить напитки!"
        static let checkInWithDrinksText = "Удерживайте понравившийся напиток полсекунды!"
        static let descriptionViewText = "Оставьте комментарий к своей локации ))"
        static let nextButtonText = "Ok!"
    }
}

// MARK: -
// MARK: Show Alert View

extension Configuration {
    func showNotifyView(_ target: UIViewController,
                        _ title: String,
                        _ message: String,
                        _ viewPosition: String,
                        _ completion: @escaping () -> Void) {
       
        var blurEffect = UIBlurEffectStyle.dark
        
        var cyberViewConfig = CFNotify.Config()
        cyberViewConfig.initPosition = .top(.random)
        cyberViewConfig.hideTime = .custom(seconds: 1.5)
        cyberViewConfig.appearPosition = .center
        
        if viewPosition == "top" {
            cyberViewConfig.appearPosition = .top
            blurEffect = UIBlurEffectStyle.init(rawValue: 7)!
            cyberViewConfig.hideTime = .custom(seconds: 3)
        }

        let customCyberView = CFNotifyView.cyberWith(title: title,
                                                     titleFont: .boldSystemFont(ofSize: 16),
                                                     titleColor: .darkBlue,
                                                     body: message,
                                                     bodyFont: .systemFont(ofSize: 14),
                                                     bodyColor: .darkBlue,
                                                     image: nil,
                                                     backgroundColor: .skyBlue,
                                                     blurStyle: blurEffect)
        
        CFNotify.present(config: cyberViewConfig, view: customCyberView)
    }
}
