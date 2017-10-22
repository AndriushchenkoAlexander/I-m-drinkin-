/*
 NetworkManager.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import Alamofire


struct Response {
    var results: Array<Any>?
    
    init(_ response: JSON) {
        results = response["results"] as? Array<Any>
    }
}


class NetworkManager {
    typealias completionHandler = (Any, String?) -> Void
    let baseUrl = EndPoints.basePath
    
    static let sharedManager = NetworkManager()
    
    func saveDeviceID(json: Any?) {
        guard let _ = DeviceID.init(json: json as! JSON) else { return }
    }
}


extension NetworkManager {
    func post(_ endpoint: EndPoints,
              _ parameters: JSON?,
              _ completion: completionHandler? = nil) {
        
        let url = baseUrl.rawValue + endpoint.rawValue
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if response.result.value != nil {
                print("======= POST Request: \(String(describing: response.request)) =======")
                print("======= POST Response: \(String(describing: response.response)) =======")
                print("======= POST Result: \(response.result) =======")
                
                if parameters == nil {
                    if let json = response.result.value {
                        print("======= GET JSON: \(json)")
                        self.saveDeviceID(json: json)
                    }
                }
            }
        }
    }
    
    func get(_ endpoint: EndPoints,
             viewController: LocationViewController,
             _ completion: completionHandler? = nil) {
        
        let url = baseUrl.rawValue + endpoint.rawValue
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.value != nil {
                print("======= GET Request: \(String(describing: response.request)) =======")
                print("======= GET Response: \(String(describing: response.response)) =======")
                print("======= GET Result: \(response.result) =======")
                
                if let json = response.result.value {
                    let response = Response.init(json as! JSON)
                    print("*** ======= JSON in result : \(String(describing: response.results))======= ***")
                    
                    viewController.parseDrunkParties(result: response.results)
                }
            }
        }
    }
}
