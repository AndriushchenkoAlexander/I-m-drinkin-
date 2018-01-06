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
    
    // MARK: -
    // MARK: - UIVisualEffectView
    
    @IBOutlet var descriptionView: UIVisualEffectView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: -
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var markersArray = [GMSMarker]()
    var userCoordinates: Coordinates?
    
    // MARK: -
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--==** CURRENT Device ID:  \n\(DeviceID.shared.loadDeviceID() ?? "ID is absent") **==--")
        
        addLongPress()
        setupLocationManager()
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.getActiveParties), userInfo: nil, repeats: true)
    }
    
    // MARK: -
    // MARK: UILongPressGestureRecognizer
    
    func addLongPress() {
        for btn in checkInWithDrinks {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init()
            longPressGesture.minimumPressDuration = 1.5
            btn.addGestureRecognizer(longPressGesture)
        }
    }
    
    func longPress() {
        descriptionViewAppearance()
        Configuration.sharedInstance.showNotifyView(self, "Добавьте подробностей", "Например: ваше имя, название заведения, локация внутри заведения, описание компании и т.д.", "top") {}
    }
    
    // MARK: -
    // MARK: IB Actions
    
    @IBAction func sendDescription(_ sender: UIButton) {
        if let text = descriptionTextView.text {
            setupActiveBoozeUp(drink: sender.tag, description: text)
            descriptionViewDisappearance()
        }
    }
    
    @IBAction func checkInButton(_ sender: UIButton) {
        isHiddenDrinkButtons()
    }
    
    @IBAction func checkInWithDrink(_ sender: UIButton) {
        isHiddenDrinkButtons()
        
        switch sender.tag {
        case 1:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
 
            let gesture = UIGestureRecognizerState.began
            
//            if gesture {
//                longPress()
//                sendButton.tag = sender.tag
//            }
        case 2:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        case 3:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        case 4:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        case 5:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        case 6:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        case 7:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        case 8:
            setupActiveBoozeUp(drink: sender.tag, description: nil)
        default:
            print("Error used checkInWithDrink")
            return
        }
    }
    
    func isHiddenDrinkButtons() {
        for drinkBtn in checkInWithDrinks {
            UIView.animate(withDuration: 0.5, animations: {
                drinkBtn.alpha = drinkBtn.alpha == 1 ? 0 : 1
            })
            drinkBtn.isHidden = drinkBtn.alpha == 0 ? true : false
        }
    }
    
    // MARK: -
    // MARK: DescriptionViews setup
    
    func descriptionViewAppearance() {
        setupDescriptionView()
        setupDescriptionTextView()
        setupDescriptionButton()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.descriptionView.alpha = 1
        }) { (true) in
            self.descriptionTextView.becomeFirstResponder()
        }
    }
    
    func descriptionViewDisappearance() {
        UIView.animate(withDuration: 0.5, animations: {
            self.descriptionView.alpha = 0
        }) { (true) in
            self.descriptionView.removeFromSuperview()
        }
    }
    
    func setupDescriptionView() {
        descriptionView.frame = view.frame
        descriptionView.alpha = 0
        
        view.addSubview(descriptionView)
    }
    
    func setupDescriptionTextView() {
        descriptionTextView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        descriptionTextView.textColor = UIColor.blackBlue
        descriptionTextView.layer.cornerRadius = 5
    }
    
    func setupDescriptionButton() {
        sendButton.backgroundColor = .skyBlue
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.blackBlue.cgColor
        sendButton.titleLabel?.textAlignment = .center
    }
    
    // MARK: -
    // MARK: Create Markers methods
    
    func parseDrunkParties(result: Results) {
        markersArray = result
            .flatMap { Mapper<BoozeUp>().map(JSONObject: $0) }
            .flatMap { setupMapMarkerWith($0) }
        
        mapView.clear()
        
        for marker in markersArray {
            marker.map = mapView
//            UIView.animate(withDuration: 0.7, animations: {
//                marker.opacity = 1
//            })
        }
    }
    
    func setupMapMarkerWith(_ boozeUp: BoozeUp) -> GMSMarker {
        let drink = String(boozeUp.drink ?? Int())
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Configuration.sharedInstance.stringToDouble(string: boozeUp.latitude), longitude: Configuration.sharedInstance.stringToDouble(string: boozeUp.longitude)))
        
        if let image = UIImagePNGRepresentation(BoozeUpIconManager(rawValue: drink).image.withRenderingMode(.automatic)) {
            let markerImage = UIImage(data: image, scale: 3.5)
            marker.icon = markerImage
            marker.title = boozeUp.txtDrink
            marker.snippet = boozeUp.description
//            marker.opacity = 0
        }
        marker.tracksInfoWindowChanges = true
        
        return marker
    }
    
    // MARK: -
    // MARK: Setup local BoozeUp
    
    func setupActiveBoozeUp(drink: Int?, description: String?) {
        startUpdateLocation()
        let parameters = createParametersForRequest(drink: drink ?? Int(), latitude: (userCoordinates?.latitude) ?? Double(), longitude: (userCoordinates?.longitude) ?? Double(), description: description)
        postPartyLocationWith(parameters: parameters)
        getActiveParties()
    }
    
    func createParametersForRequest(drink: Int, latitude: Double, longitude: Double, description: String?) -> [String: Any] {
        var dictParameter: Dictionary<String, Any> = [:]
        
        if let deviceID = DeviceID.shared.loadDeviceID() {
            dictParameter["device"]      = deviceID
            dictParameter["drink"]       = drink
            dictParameter["latitude"]    = Configuration.sharedInstance.stringCoordinates(double: latitude)
            dictParameter["longitude"]   = Configuration.sharedInstance.stringCoordinates(double: longitude)
            dictParameter["description"] = description
        }
        return dictParameter
    }
    
    // MARK: -
    // MARK: Network requests
    
    @objc func getActiveParties() {
        NetworkManager.sharedManager.get(self, EndPoints.sharedInstance.getActiveBoozeUp()) { (response) in
            guard let baseResponse = response as? BaseResponse else { return }
            self.parseDrunkParties(result: baseResponse.results ?? Results())
            //print("====== LocationViewController GET results data --- >> \n \n\(baseResponse.results ?? Results()) \n \n======\n")
        }
    }
    
    func postPartyLocationWith(parameters: Dictionary<String, Any>) {
        NetworkManager.sharedManager.post(self, EndPoints.sharedInstance.createBoozeUp(), parameters, { (response) in
            guard let response = response as? BaseResponse else { return }
            guard let details = response.details else { return }
            Configuration.sharedInstance.showNotifyView(self, "Warning!", details, "center") {}
            //print("====== LocationViewController POST results data --- >> \n \n\(details)) \n \n======\n")
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
