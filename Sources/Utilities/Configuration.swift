//
//  Config.swift
//  I am drinking
//
//  Created by astronauttux on 18.10.17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import UIKit


final class Configuration {
    static let sharedInstance = Configuration()
    private init() {}
    
    // MARK: -
    // MARK: Convert String to Double
    
    func stringToDouble(string: String?) -> Double {
        var newValue = 0.0
        
        if let lat = string {
            newValue = Double(lat) ?? 0.0
        }
        return newValue
    }
    
    // MARK: -
    // MARK: Show Alert View
    
    func showAlert(_ target: UIViewController,
                   _ title: String,
                   _ message: String,
                   _ buttonTitle: AlerButtonTitle,
                   completion: @escaping () -> Void) {
        //target.dismiss(animated: true, completion: nil)
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: buttonTitle.rawValue, style: .default) { action -> Void in ( completion() )}
        actionSheetController.addAction(closeAction)
        
        target.present(actionSheetController, animated: true, completion: nil)
    }
}

enum AlerButtonTitle: String {
    case close = "Close"
    case ok = "OK"
}
