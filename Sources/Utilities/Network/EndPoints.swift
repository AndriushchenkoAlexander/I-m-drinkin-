/*
  EndPoints.swift
  I am drinking

  Created by astronauttux on 12.10.17.
  Copyright © 2017 Vadym Yakovliev. All rights reserved.
*/

import Foundation


enum EndPoints: String {
    case basePath = "http://www.iamdrinking.localhost8080.pp.ua/core/api/v1.0/"
    case device = "device/"
    case activeBoozeUp = "drunk/active/"
    case drunk = "drunk/"
    
    init(rawValue: String) {
        switch rawValue {
        case "basePath": self = .basePath
        case "device": self = .device
        case "activeDevice": self = .activeBoozeUp
        case "drunk": self = .drunk
        default: self = .basePath
        }
    }
}
