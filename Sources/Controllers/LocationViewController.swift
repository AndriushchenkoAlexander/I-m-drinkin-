/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import GoogleMaps
import ObjectMapper

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet var checkInWithDrinks: [UIButton]!
    
    
    let locationManager = CLLocationManager()
    var markersArray = [GMSMarker]()
    var userCoordinates: Coordinates?
    
    // MARK: -
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--==** CURRENT Device ID:  \n\(DeviceID.shared.loadDeviceID() ?? "ID is absent") **==--")
        
        setupLocationManager()
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getActiveParties), userInfo: nil, repeats: true)
    }
    
    // MARK: -
    // MARK: IB Actions
    
    @IBAction func checkInButton(_ sender: UIButton) {
        isHiddenDrinkButtons()
    }
    
    @IBAction func checkInWithDrink(_ sender: UIButton) {
        isHiddenDrinkButtons()
        
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
    
    func isHiddenDrinkButtons() {
        for drink in checkInWithDrinks {
            UIView.animate(withDuration: 0.5, animations: {
                drink.alpha = drink.alpha == 1 ? 0 : 1
            })
        }
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
        
        mapView.clear()
        
        for marker in markersArray {
            marker.map = mapView
            UIView.animate(withDuration: 0.7, animations: {
                marker.opacity = 1
            })
        }
    }
    
    func setupMapMarker(latitude: String?, longitude: String?, drink: Int) -> GMSMarker {
        
        let drink = String(drink)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Configuration.sharedInstance.stringToDouble(string: latitude), longitude: Configuration.sharedInstance.stringToDouble(string: longitude)))
        
        if let image = UIImagePNGRepresentation(BoozeUpIconManager.init(rawValue: drink).image.withRenderingMode(.automatic)) {
            let markerImage = UIImage(data: image, scale: 3.5)
            marker.icon = markerImage
            marker.opacity = 0
        }
        marker.tracksInfoWindowChanges = true

        return marker
    }
    
    // MARK: -
    // MARK: Setup local BoozeUp
    
    func setupActiveBoozeUp(drink: Int?) {
        startUpdateLocation()
        let parameters = createParametersForRequest(drink: drink ?? Int(), latitude: (userCoordinates?.latitude) ?? Double(), longitude: (userCoordinates?.longitude) ?? Double())
        postPartyLocationWith(parameters: parameters)
        getActiveParties()
    }
    
    func createParametersForRequest(drink: Int, latitude: Double, longitude: Double) -> [String: Any] {
        var dictParameter: Dictionary<String, Any> = [:]
        
        if let deviceID = DeviceID.shared.loadDeviceID() {
            dictParameter["device"]     = deviceID
            dictParameter["drink"]      = drink
            dictParameter["latitude"]   = Configuration.sharedInstance.stringCoordinates(double: latitude)
            dictParameter["longitude"]  = Configuration.sharedInstance.stringCoordinates(double: longitude)
        }
        return dictParameter
    }
    
    // MARK: -
    // MARK: Network requests
    
    @objc func getActiveParties() {
        NetworkManager.sharedManager.get(self, EndPoints.sharedInstance.getActiveBoozeUp()) { (response) in
            if let baseResponse = response as? BaseResponse {
                print("====== LocationViewController GET results data --- >> \n \n\(baseResponse.results ?? Results()) \n \n======\n")
                self.parseDrunkParties(result: baseResponse.results ?? Results())
            }
        }
    }
    
    func postPartyLocationWith(parameters: Dictionary<String, Any>) {
        NetworkManager.sharedManager.post(self, EndPoints.sharedInstance.createBoozeUp(), parameters, { (response) in
            
            if let response = response as? BaseResponse {
                
                if let details = response.details {
                    print("====== LocationViewController POST results data --- >> \n \n\(details)) \n \n======\n")
                    Configuration.sharedInstance.showAlert(self, "Warning!", details, .ok) {}
                }
            }
        })
    }
}

// MARK: -
// MARK: - CLLocationManagerDelegate

extension LocationViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // Use the highest-level of accuracy
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // This function is called when the user grants or does not grant you the right to determine its location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdateLocation()
            
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = true
        }
    }
    
    // When update a geographic position, this delegate's method is called:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            
            let latitude = Double(location.coordinate.latitude)
            let longitude = Double(location.coordinate.longitude)
            userCoordinates = Coordinates(latitude: latitude, longitude:longitude)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}
