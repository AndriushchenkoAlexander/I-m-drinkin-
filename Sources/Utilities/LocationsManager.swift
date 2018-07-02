/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import CoreLocation

protocol LocationManagerDelegate: class {
    
    func fetchCurrentLocation(coordinates: Coordinates)
}

final class LocationManager: NSObject {
    
    static let shared: LocationManager = {
        return LocationManager()
    }()
    
    private override init() {
        super.init()
    }
    
    weak var delegate: LocationManagerDelegate?
    
    private let coreLocationManager = CLLocationManager()
}

// MARK: -
// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func launchLocationManager() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            coreLocationManager.delegate = self
            coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                coreLocationManager.startUpdatingLocation()
            } else {
                coreLocationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("authorization checked...")
        
        switch status {
        case .notDetermined:
            
            coreLocationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            
            coreLocationManager.startUpdatingLocation()
        case .authorizedAlways:
            
            coreLocationManager.startUpdatingLocation()
        case .restricted:
            
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let latitude = Double(location.coordinate.latitude)
            let longitude = Double(location.coordinate.longitude)
            
            let userCoordinates = Coordinates(latitude: latitude, longitude: longitude)
            delegate?.fetchCurrentLocation(coordinates: userCoordinates)
            
            coreLocationManager.stopUpdatingLocation()
        }
    }
}
