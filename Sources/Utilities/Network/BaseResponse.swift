//
//  BaseResponse.swift
//  I am drinking
//
//  Created by Vadim Yakovlev on 11/14/17.
//  Copyright © 2017 Vadym Yakovliev. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    var results: Results?
    
    required convenience init?(map: Map) { self.init() }
    
//    init(_ response: JSON) {
//        results = response["results"] as? Results
//    }
    func mapping(map: Map) {
        results      <- map["results"]
    }
}
