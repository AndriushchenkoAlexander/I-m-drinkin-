//
//  Double+RoundPlaces.swift
//  I am drinking
//
//  Created by Vadim Yakovlev on 11/20/17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import Foundation


extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
