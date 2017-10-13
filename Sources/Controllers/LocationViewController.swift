/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import Appodeal
import GoogleMaps


class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView?
    
    let locationManager = CLLocationManager()
    var markersArray = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setupBanner()
        self.setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedManager.get(.activeBoozeUp, nil)
    }
    
    func parseDrunkParties(result: Array<Any>?) {
        if result != nil {
            for boozeUp in result! {
                if let drunkParty = BoozeUp.init(json: boozeUp as! JSON) {
                    let marker = setupMapMarker(latitude: drunkParty.latitude, longitude: drunkParty.longitude, drink: drunkParty.drink)
                    markersArray = [marker]
//                    print("======= Unwrap dictionaties: \(String(describing: drunkParty))")
                }
            }
            print("======= Objects in markersArray: \(String(describing: markersArray))")
            for marker in markersArray {
               marker.map = mapView
            }
        }
    }
    
    func setupMapMarker(latitude: String?, longitude: String?, drink: Int?) -> GMSMarker {
        
        let drink = String(describing: drink)
        let markerImage = (BoozeUpIconManager.init(rawValue: drink).image).withRenderingMode(.automatic)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: stringToDouble(string: latitude), longitude: stringToDouble(string: longitude)))
        marker.tracksInfoWindowChanges = true
        marker.icon = markerImage
        
        return marker
    }
    
    func stringToDouble(string: String?) -> Double {
        var newValue = 0.0
        
        if let lat = string {
            newValue = Double(lat) ?? 0.0
        }
        return newValue
    }
    
    @IBAction func checkInButton(_ sender: Any) {
        
    }
}

// MARK: - AppodealBannerDelegate
extension LocationViewController: AppodealBannerDelegate {
    func setupBanner() {
        AdsManager.sharedManager.setBannerAndShowAD(setViewController: self)
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Use the highest-level of accuracy
        locationManager.requestWhenInUseAuthorization()
    }
    
    // This function is called when the user grants or does not grant you the right to determine its location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = true
        }
    }
    
    // When update a geographic position, this delegate's method is called:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            self.locationManager.stopUpdatingLocation()
        }
    }
}
