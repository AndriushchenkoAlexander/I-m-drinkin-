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
    let baseUrl = EndPoints.basePath
    
    static let sharedManager = NetworkManager()
    private init() {}
}


extension NetworkManager {
    func post(_ target: UIViewController?,
              _ url: EndPoints,
              _ parameters: Parameters?,
              _ completion: @escaping (ResponseData?) -> ()) {
        
        print("== POST Request to:", url)
        print("==== with parameters:", parameters ?? "")
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            
            .responseObject{ (response: DataResponse<BaseResponse>) in
                self.setupResponse(target: target, response: response, completion: completion)
        }
    }
    
    func get(_ target: UIViewController?,
             _ url: EndPoints,
             _ completion: @escaping (ResponseData?) -> ()) {
        
        print("== GET Request to:", url)

        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default)
            
            .responseObject { (response: DataResponse<BaseResponse>) in
                self.setupResponse(target: target, response: response, completion: completion)
        }
    }
    
    func setupResponse(target: UIViewController?, response: DataResponse<BaseResponse>, completion: (ResponseData?) -> ()) {
        switch response.result {
            
        case .success:
            print("====== Response Result:", String(describing: (response.result.value?.success)!))
            
            if (response.result.value?.success)! {
                print("====== Response data", response.result.value?.data ?? "")
                completion(response.result.value?.data)
            } else {
                let message = response.result.value?.description ?? ""
                if let target = target { Configuration.sharedInstance.showAlert(target, "Error", message, .ok) {} }
            }
        case .failure(let error):
            print("--== Сase ERROR Response -- !! \(error) !!")
        }
    }
}
