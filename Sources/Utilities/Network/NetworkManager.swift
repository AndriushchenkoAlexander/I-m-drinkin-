/*
 NetworkManager.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import Alamofire
import AlamofireObjectMapper


class NetworkManager {
    static let sharedManager = NetworkManager()
    private init() {}
}

// MARK: -
// MARK: Network layer

extension NetworkManager {
    func post(_ target: UIViewController?,
              _ url: String,
              _ parameters: Parameters?,
              _ completion: @escaping (Any) -> ()) {
        
        print("== POST Request to:  \n", url)
        print("==== with parameters:  \n", parameters ?? "No parameters" )
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default).validate()
            
            .responseJSON { response in
                self.setupResponse(target: target, response: response, completion: completion)
        }
    }
    
    func get(_ target: UIViewController?,
             _ url: String,
             _ completion: @escaping (Any) -> ()) {
        
        print("== GET Request to:  \n", url)
        
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default).validate()
            
            .responseJSON { response in
                self.setupResponse(target: target, response: response, completion: completion)
        }
    }
    
    func setupResponse(target: UIViewController?, response: DataResponse<Any>, completion: (Any?) -> ()) {
        switch (response.result) {
            
        case .success:
            print("====== Response Result: - > \n", String(describing: (response.result)))
            
            if let response = response.result.value {
                print("====== Response data - > \n", response)
                completion(response)
            }
            
        case .failure(let error):
            
            if let statusCode = response.response?.statusCode {
                
                print("--== Сase ERROR Response -- !! - > \n    \(error.localizedDescription) \n")
                print("--== Status Code in ERROR Response -- !! - > \n    \(String(describing: statusCode)) \n")
                
                let message = error.localizedDescription + "Status code:\(statusCode)"
                if let target = target { Configuration.sharedInstance.showAlert(target, "Error", message, .ok) {} }
            }
        }
    }
}
