/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import GoogleMaps
import ObjectMapper

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView?
    
    let locationManager = CLLocationManager()
    var markersArray = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deviceID = DeviceID()
        print("--==** CURRENT Device ID:  \(deviceID.getDeviceID() ?? "ID is absent")**==--")
        
        self.setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedManager.get(self, EndPoints.sharedInstance.getActiveBoozeUp()) { (response) in
            
        }
//            if let drunkPartiesArray = response as? Array<Any> {
//                for drunkParties in drunkPartiesArray {
//                    if let drunkParties = Mapper<BoozeUp>().map(JSONObject: response) {
//                        
//                    }
//                }
//            }
        }


    func parseDrunkParties() {
        
    }
    
    /*
    func parseDrunkParties(result: Array<Any>?) {
        if result != nil {
            for boozeUp in result! {
                if let drunkParty = BoozeUp.init(json: boozeUp as! JSON) {
                    let marker = setupMapMarker(latitude: drunkParty.latitude, longitude: drunkParty.longitude, drink: drunkParty.drink ?? 0)
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
    */
    
    func setupMapMarker(latitude: String?, longitude: String?, drink: Int) -> GMSMarker {
        
        let drink = String(describing: drink)
        let markerImage = (BoozeUpIconManager.init(rawValue: drink).image).withRenderingMode(.alwaysTemplate)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Configuration.sharedInstance.stringToDouble(string: latitude), longitude: Configuration.sharedInstance.stringToDouble(string: longitude)))
        marker.tracksInfoWindowChanges = true
        //        marker.title = "Hello!!"
        marker.icon = markerImage
        
        return marker
    }
    
    func createParametersForRequest(device: String, drink: String, latitude: Double, longitude: Double) -> [String: Any] {
        var dictParameter: Dictionary<String, Any> = [:]
        
        dictParameter["device"]     = device
        dictParameter["drink"]      = drink
        dictParameter["latitude"]   = latitude
        dictParameter["longitude"]  = longitude
        
        return dictParameter
    }
    
    @IBAction func checkInButton(_ sender: Any) {
        
    }
    
    @IBAction func checkInWithDrink(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        //
        //        switch button.tag {
        //        case 1:
        //           NetworkManager.sharedManager.post(.drunk, <#T##parameters: JSON?##JSON?#>)
        //        case 2:
        //
        //        case 3:
        //
        //        case 4:
        //
        //        case 5:
        //
        //        case 6:
        //
        //        case 7:
        //
        //        case 8:
        //
        //        default:
        //            print("Error used checkInWithDrink")
        //            return
        //        }
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
