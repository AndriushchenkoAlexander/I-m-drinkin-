/*
  NetworkRouter.swift
  I am drinking

  Created by Vadim Yakovlev on 6/29/18.
  Copyright © 2018 Vadym Yakovliev. All rights reserved.
*/

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
