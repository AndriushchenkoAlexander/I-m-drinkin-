/*
  EndPoints.swift
  I am drinking

  Created by astronauttux on 12.10.17.
  Copyright © 2017 Vadym Yakovliev. All rights reserved.
*/

import Foundation


struct EndPoints {
    static let sharedInstance = EndPoints()
    private init() {}
    
    let baseUrl = "http://www.iamdrinking.localhost8080.pp.ua/core/api/"

    // MARK: -
    // MARK: POST & GET Requests
    
    func createNewDeviceID()                     -> String {    return baseUrl + "device/"                          }   // POST (empty)
    func getActiveBoozeUp()                      -> String {    return baseUrl + "drunk/active/"                    }   // GET
    func createBoozeUp()                         -> String {    return baseUrl + "drunk/"                           }   // POST
}
