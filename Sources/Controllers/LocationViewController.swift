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
    
    // MARK: -
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("--==** CURRENT Device ID:  \n\(DeviceID.getDeviceID() ?? "ID is absent")**==--")
        
        getActiveParties()
    }
    
    // MARK: -
    // MARK: Create Markers methods
    
    func parseDrunkParties(result: Results) {
        for drunkPartie in result {
            if let activeBoozeUp = Mapper<BoozeUp>().map(JSONObject: drunkPartie) {
                let marker = setupMapMarker(latitude: activeBoozeUp.latitude, longitude: activeBoozeUp.longitude, drink: activeBoozeUp.drink ?? 0)
                markersArray += [marker]
            }
        }
        for marker in markersArray {
            marker.map = mapView
        }
    }
    
    func setupMapMarker(latitude: String?, longitude: String?, drink: Int) -> GMSMarker {
        
        let drink = String(describing: drink)
        let markerImage = (BoozeUpIconManager.init(rawValue: drink).image).withRenderingMode(.automatic)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Configuration.sharedInstance.stringToDouble(string: latitude), longitude: Configuration.sharedInstance.stringToDouble(string: longitude)))
        marker.tracksInfoWindowChanges = true
        marker.icon = markerImage
        
        return marker
    }
    
    // MARK: -
    // MARK: IB Actions
    
    @IBAction func checkInButton(_ sender: Any) {
        
    }
    
    @IBAction func checkInWithDrink(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            setupActiveBoozeUp(drink: sender.tag)
        case 2:
            setupActiveBoozeUp(drink: sender.tag)
        case 3:
            setupActiveBoozeUp(drink: sender.tag)
        case 4:
            setupActiveBoozeUp(drink: sender.tag)
        case 5:
            setupActiveBoozeUp(drink: sender.tag)
        case 6:
            setupActiveBoozeUp(drink: sender.tag)
        case 7:
            setupActiveBoozeUp(drink: sender.tag)
        case 8:
            setupActiveBoozeUp(drink: sender.tag)
        default:
            print("Error used checkInWithDrink")
            return
        }
    }

    // MARK: -
    // MARK: Setup local BoozeUp
    
    func setupActiveBoozeUp(drink: Int?) {
        if let userCoordinates = setupUserLocation() {
            let parameters = createParametersForRequest(drink: drink ?? Int(), latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
            print("====== LocationViewController sending this data --- >> \n \n\(parameters) \n \n======\n")
            postPartyLocationWith(parameters: parameters)
        }
    }
    
    func createParametersForRequest(drink: Int, latitude: Double, longitude: Double) -> [String: Any] {
        var dictParameter: Dictionary<String, Any> = [:]
        
        if let deviceID = DeviceID.getDeviceID() {
            dictParameter["device"]     = deviceID
            dictParameter["drink"]      = drink
            dictParameter["latitude"]   = latitude
            dictParameter["longitude"]  = longitude
        }
        return dictParameter
    }
    
    // MARK: -
    // MARK: Network requests
    
    func getActiveParties() {
        NetworkManager.sharedManager.get(self, EndPoints.sharedInstance.getActiveBoozeUp()) { (response) in
            if let baseResponse = response as? BaseResponse {
                print("====== LocationViewController GET results data --- >> \n \n\(baseResponse.results ?? Results()) \n \n======\n")
                self.parseDrunkParties(result: baseResponse.results ?? Results())
            }
        }
    }
    
    
    func postPartyLocationWith(parameters: Dictionary<String, Any>) {
        NetworkManager.sharedManager.post(self, EndPoints.sharedInstance.createBoozeUp(), parameters, { (response) in
            if let description = response as? BaseResponse {
                print("====== LocationViewController POST results data --- >> \n \n\(String(describing: description.details)) \n \n======\n")
                Configuration.sharedInstance.showAlert(self, "Warning!", description.details ?? "Something wrong!", .ok) {}
            }
        })
    }
}

    // MARK: -
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
    
    func setupUserLocation() -> Coordinates? {
        let locations = [CLLocation]()
        if let userLocation = locations.last {
            let latitude = Double(userLocation.coordinate.latitude)
            let longitude = Double(userLocation.coordinate.longitude)
            let userCoordinates = Coordinates(latitude: latitude, longitude:longitude)
            
            return userCoordinates
        }
        return nil
    }
}
