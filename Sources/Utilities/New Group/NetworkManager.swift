/*
 NetworkManager.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import Foundation
import Alamofire


enum endPoints: String{
    case baseUrl = ""
    case basePath = "http://www.iamdrinking.localhost8080.pp.ua/core/api/"
    case device = "device/"
    case activeDevice = "device/active/"
    case drunk = "drunk/"
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
    let baseUrl = endPoints.baseUrl.rawValue + endPoints.basePath.rawValue
    
    static let sharedManager = NetworkManager()
    //    private var networkManager: SessionManager!
    
    private init() {
        //        networkManager = Alamofire.SessionManager.default
    }
    
    func saveDeviceID(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
            _ = DeviceID.init(JSON: json as! [String : AnyObject])
        } catch {
            print("=== ERROR: \(error) ===")
        }
    }
}

extension NetworkManager {
    func post(_ endpoint: endPoints,
              _ parameters: [String : String]?,
              _ completion: completionHandler? = nil) {
        
        let url = baseUrl + endpoint.rawValue
        print(url)
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if let result = response.data {
                print("======= RESULT OF POST REQUEST: \(result)=======")
                if parameters == nil {
                    self.saveDeviceID(data: result)
                }
            }
        }
    }  
}
