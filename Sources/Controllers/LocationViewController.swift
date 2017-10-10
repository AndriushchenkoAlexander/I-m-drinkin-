/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import Appodeal
import GoogleMaps


class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanner()
        setupLocationManager()
        NetworkManager.sharedManager.networkRequest(url: kURLForCoreAPI)
    }
}


// MARK: - AppodealBannerDelegate
extension LocationViewController: AppodealBannerDelegate {
    func setupBanner() {
        AdsManager.setBannerAndShowAD(setViewController: self)
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // Use the highest-level of accuracy
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // This function is called when the user grants or does not grant you the right to determine its location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            self.locationManager.startUpdatingLocation()
            
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
        }
    }
    
    // When update a geographic position, this delegate's method is called:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0) 
            self.locationManager.stopUpdatingLocation()
        }
    }
}

