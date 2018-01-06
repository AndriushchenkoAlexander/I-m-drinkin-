/*
 NetworkManager.swift
 I'm drinkin'
 
 Created by astronauttux on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import Alamofire
import ObjectMapper

class NetworkManager {
    static let sharedManager = NetworkManager()
    private init() {}
}

extension NetworkManager {
    // MARK: -
    // MARK: POST
    
    func post(_ target: UIViewController?,
              _ url: String,
              _ parameters: Parameters?,
              _ completion: @escaping (Any?) -> ()) {
        
//        print("== POST Request to:  \n", url)
//        print("==== with parameters:  \n", parameters ?? "No parameters" )
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            
            .responseJSON { response in
                self.setupResponse(target: target, response: response, completion: completion)
        }
    }
    
    // MARK: -
    // MARK: GET
    
    func get(_ target: UIViewController?,
             _ url: String,
             _ completion: @escaping (Any?) -> ()) {
        
//        print("== GET Request to:  \n", url)
        
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default)
            
            .responseJSON { response in
                self.setupResponse(target: target, response: response, completion: completion)
        }
    }
    
    // MARK: -
    // MARK: Setup of Response
    
    func setupResponse(target: UIViewController?, response: DataResponse<Any>, completion: (Any?) -> ()) {
        switch (response.result) {
            
        case .success:
//            print("====== Response Result: - > \n", response.result)
//            print("====== Response data - > \n", response.result.value ?? "NO DATA RESPONSE")
            
            if let json = response.result.value {
                let response = Mapper<BaseResponse>().map(JSONObject: json)
                completion(response)
            }
            
        case .failure(let error):
            print("--== Сase ERROR Response -- !! - > \n    \(error.localizedDescription) \n")
            guard let statusCode = response.response?.statusCode else { return }
            print("--== Status Code in ERROR Response -- !! - > \n    \(statusCode) \n")
            let message = error.localizedDescription + "\nStatus code:\(statusCode)"
            guard let target = target else { return }
            Configuration.sharedInstance.showNotifyView(target, "Error", message, "center") {}
            //if let target = target { Configuration.sharedInstance.showAlert(target, "Error", message, .ok) {} }
        }
    }
}
