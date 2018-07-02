/*
 Config.swift
 I am drinking
 
 Created by astronauttux on 18.10.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit

final class AlertView {
    static let sharedInstance = AlertView()
    private init() { }
    
    struct CoachMarkText {
        static let checkInButtonText = "Нажмите, что бы отобразить напитки!"
        static let checkInWithDrinksText = "Удерживайте понравившийся напиток полсекунды!"
        static let descriptionViewText = "Оставьте комментарий к своей локации ))"
        static let nextButtonText = "Ok!"
    }
}

// MARK: -
// MARK: Show Alert View

extension AlertView {
    func showAlert(title: String?,
                   message: String?,
                   actions: [UIAlertAction],
                   style: UIAlertControllerStyle) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.view.tintColor = #colorLiteral(red: 0.2117647059, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
        alertController.view.subviews.first?.subviews.first?.alpha = 0.7
        actions.forEach(alertController.addAction(_:))
        
        alertController.show()
    }
}
