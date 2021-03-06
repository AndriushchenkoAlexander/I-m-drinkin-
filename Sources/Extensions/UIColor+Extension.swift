//
//  UIColor+Extension.swift
//  I am drinking
//
//  Created by Vadim Yakovlev on 12/15/17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import UIKit


extension UIColor {
    static let blackBlue = { () -> UIColor in
        let color = UIColor(red:0.02, green:0.13, blue:0.14, alpha:1.0)
        return color
    }()
    
    static let darkBlue = { () -> UIColor in
        let color = UIColor(red:0.07, green:0.32, blue:0.61, alpha:1.0)
        return color
    }()
    
    static let skyBlue = { () -> UIColor in
        let color = UIColor(red:0.47, green:0.78, blue:0.83, alpha:1.0)
        return color
    }()
}
