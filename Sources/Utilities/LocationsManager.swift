/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import GoogleMaps

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

class LocationsManager {
    static let sharedManager = LocationsManager()
    private init() {}
    
    func locationProvideAPIKey(){
        GMSServices.provideAPIKey(ApiKeys.googleMapsApiKey)
    }
}
