/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import GoogleMaps

struct LocationsManager {
    
    static func locationProvideAPIKey(){
        GMSServices.provideAPIKey(kGoogleMapsApiKey)
        GMSPlacesClient.provideAPIKey(kGooglePlacesApiKey)
    }
    
        
    //    placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
    //    if let error = error {
    //    print("Pick Place error: \(error.localizedDescription)")
    //    return
    //    }
    //
    //    if let placeLikelihoodList = placeLikelihoodList {
    //    for likelihood in placeLikelihoodList.likelihoods {
    //    let place = likelihood.place
    //    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
    //    print("Current Place address \(place.formattedAddress)")
    //    print("Current Place attributions \(place.attributions)")
    //    print("Current PlaceID \(place.placeID)")
    //    }
    //    }
    //    })
    //
    //    func setupMapMarker() {
    //        // Creates a marker in the center of the map.
    //        let marker = GMSMarker()
    //        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: latitude)
    //        marker.title = ""
    //        marker.snippet = ""
    //        marker.map = mapView
    //    }
}


