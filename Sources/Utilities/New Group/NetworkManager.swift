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
    let baseUrl = endPoints.baseUrl.rawValue + endPoints.basePath.rawValue
    
    static let sharedManager = NetworkManager()
    //    private var networkManager: SessionManager!
    
    private init() {
        //        networkManager = Alamofire.SessionManager.default
    }
    
    func fetchDeviceID(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
            _ = DeviceID.init(JSON: json as! [String : AnyObject])
        } catch {
            print(error)
        }
    }
}

extension NetworkManager {
    func post(_ target: UIViewController?,
              _ endpoint: endPoints,
              _ parameters: [String:String]?,
              _ completion: completionHandler? = nil) {
        
        let url = baseUrl + endpoint.rawValue
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if let result = response.data {
                print(result)
                if parameters == nil {
                    self.fetchDeviceID(data: result)
                }
            }
        }
    }  
}
