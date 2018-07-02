/*
 ParameterEncoding.swift
 I am drinking
 
 Created by Vadim Yakovlev on 6/29/18.
 Copyright © 2018 Vadym Yakovliev. All rights reserved.
 */

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest,
                       with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter encoding failed"
    case missingURL = "URL is nil"
}
