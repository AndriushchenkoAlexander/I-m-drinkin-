/*
 HTTPTask.swift
 I am drinking
 
 Created by Vadim Yakovlev on 6/29/18.
 Copyright © 2018 Vadym Yakovliev. All rights reserved.
 */

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        urlParameters: Parameters?)
    
    case requestParametersHeaders(bodyParameters: Parameters?,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload... etc
}
