/*
  EndPointType.swift
  I am drinking

  Created by Vadim Yakovlev on 6/29/18.
  Copyright © 2018 Vadym Yakovliev. All rights reserved.
*/

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

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
