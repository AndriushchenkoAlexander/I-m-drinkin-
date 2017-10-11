/*
 NetworkManager.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation
import Alamofire


enum endPoints: String{
    case baseUrl = "http://"
    case basePath = "www.iamdrinking.localhost8080.pp.ua/core/api/"
    case device = "device/"
    case drunk = "drunk/"
    case active = "active/"
}

struct Response {
    var status: Bool!
    var message: String!
    var results: [String:AnyObject]!
    
    init(_ response: [String:AnyObject]) {
        status = response["status"] as? Bool
        message = response["message"] as? String
        results = response["results"] as? [String:AnyObject]
    }
}

class NetworkManager {
    typealias completionHandler = (Any, String?) -> Void
    static let baseUrl = endPoints.baseUrl.rawValue + endPoints.basePath.rawValue
    
    static let sharedManager = NetworkManager()
//    private var networkManager: SessionManager!
    
    private init() {
//        networkManager = Alamofire.SessionManager.default
    }
}

extension NetworkManager {
    class func post(_ target: UIViewController?,
                    _ endpoint: endPoints,
                    _ parameters: [String:String]?,
                    _ completion: completionHandler? = nil) {
        
        let url = baseUrl + endpoint.rawValue
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
//                       let result = JSON(response.data!)
            //            if result["success"].boolValue {
            //                keychain.set(result["data"].stringValue, forKey: "access_token")
            //                completionHandler!(true, nil)
            //                if let token = keychain.get("device_token") {
            //                    self.passDeviceToken(token: token)
            //                }
            //            } else {
            //                completionHandler!(false, result["data"]["errors"]["description"].stringValue)
            //            }
        }
    }
    
}
