/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import GoogleMaps


class LocationsManager {
    static let sharedManager = LocationsManager()
    private init() {}
    //    private let locationManager = CLLocationManager()
    //    static var viewController = UIViewController()
    //    static var mapView = GMSMapView()
    
    // MARK: -
    // MARK: Network layer
    
    func locationProvideAPIKey(){
        GMSServices.provideAPIKey(ApiKeys.googleMapsApiKey)
    }
    
    /*
     static func setupMapWithViewController(vc: UIViewController, mapView: GMSMapView) {
     self.viewController = vc
     self.mapView = mapView
     }
     */
    //    func setupMapMarker() {
    //        // Creates a marker in the center of the map.
    //        let marker = GMSMarker()
    //        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: latitude)
    //        marker.title = ""
    //        marker.snippet = ""
    //        marker.map = mapView
    //    }
}

/*
 // MARK: - CLLocationManagerDelegate
 extension LocationsManager: CLLocationManagerDelegate {
 private func setupLocationManager() {
 locationManager.delegate = self as CLLocationManagerDelegate
 locationManager.desiredAccuracy = kCLLocationAccuracyBest // Use the highest-level of accuracy
 locationManager.requestWhenInUseAuthorization()
 }
 
 // This function is called when the user grants or does not grant you the right to determine its location
 internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 if status == .authorizedWhenInUse {
 
 locationManager.startUpdatingLocation()
 
 LocationsManager.mapView.isMyLocationEnabled = true
 LocationsManager.mapView.settings.myLocationButton = true
 }
 }
 
 // When update a geographic position, this delegate's method is called:
 internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 if let location = locations.first {
 
 LocationsManager.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
 //            mapView.animate(to: mapView.camera)
 locationManager.stopUpdatingLocation()
 }
 }
 
 }
 */
