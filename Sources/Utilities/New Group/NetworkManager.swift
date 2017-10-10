/*
  NetworkManager.swift
  I'm drinkin'

  Created by astronauttux on 20.09.17.
  Copyright © 2017 Vadym Yakovliev. All rights reserved.
*/

import Foundation
import Alamofire

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    private let networkManager: SessionManager!
    
    private init() {
        networkManager = Alamofire.SessionManager.default
    }
    
    func networkRequest(url: String) {
//        let configuration = URLSessionConfiguration.default
//        let request = self.networkManager
        request(url).responseJSON { response in
            print(response)
        }
        print("networkRequest ended")
    }
}
