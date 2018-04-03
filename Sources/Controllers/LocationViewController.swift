/*
 I'm drinkin'
 
 Created by vadim@yakovliev.co.ua on 20.09.17.
 Copyright © 2017 Vadym Yakovliev. All rights reserved.
 */

import UIKit
import GoogleMaps
import ObjectMapper
import Instructions

internal class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet var checkInWithDrinks: [UIButton]!
    
    // MARK: -
    // MARK: - UIVisualEffectView Properties
    
    @IBOutlet var addItemView: UIView!
    @IBOutlet var descriptionView: UIVisualEffectView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    var effect: UIVisualEffect!
    
    // MARK: - Instructions propertie
    
    var coachMarksController = CoachMarksController()
    
    // MARK: -
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var markersArray = [GMSMarker]()
    var currentMarker : GMSMarker?
    var userCoordinates: Coordinates?
    var isButtonsHidden = true
    
    // MARK: -
    // MARK: Animations for description
    
    func animateIn() {
        view.addSubview(addItemView)
        addItemView.center = descriptionView.center
        
        addItemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let `self` = self else { return }
            
            self.descriptionView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let `self` = self else { return }
            
            self.addItemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            
            self.descriptionView.effect = nil
            
        }) { (Bool) in
            
            self.addItemView.removeFromSuperview()
        }
    }
    
    private func setupDescription() {
        effect = descriptionView.effect
        descriptionView.effect = nil
        
        addItemView.layer.cornerRadius = 5
    }
    
    // MARK: -
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--==** CURRENT Device ID:  \n\(DeviceID.shared.loadDeviceID() ?? "ID is absent") **==--")
        
        setupInstructions()
        
        setupDescription()
        addLongPress()
        mapView.delegate = self
        
        setupLocationManager()
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.getActiveParties), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        coachMarksController.start(on: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        coachMarksController.stop(immediately: true)
    }
    
    // MARK: -
    // MARK: - Instructions
    
    private func setupInstructions() {
        coachMarksController.dataSource = self
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        coachMarksController.skipView = skipView
    }
    
    // MARK: -
    // MARK: UILongPressGestureRecognizer
    
    func addLongPress() {
        for btn in checkInWithDrinks {
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.minimumPressDuration = 0.5
            btn.addGestureRecognizer(longPressGesture)
        }
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        guard let button = sender.view as? UIButton else { return }
        descriptionViewAppearance(buttonTag: button.tag)
        Configuration.sharedInstance.showNotifyView(self, "Добавьте подробностей", "Например: ваше имя, название заведения, локация внутри заведения, описание компании и т.д.", "top") {}
    }
    
    // MARK: - Current Marker Actions
    func removeCurrentMarker() {
        currentMarker?.map = nil
        currentMarker = nil
    }
    
    // MARK: -
    // MARK: IB Actions
    
    @IBAction func sendDescription(_ sender: UIButton) {
        if let text = descriptionTextView.text {
            setupActiveBoozeUp(drink: sender.tag, description: text)
            animateOut()
        }
        
        hideOrShowButtons()
    }
    
    @IBAction func checkInButton(_ sender: UIButton) {
        removeCurrentMarker()
        hideOrShowButtons()
    }
    
    @IBAction func checkInWithDrink(_ sender: UIButton) {
        hideOrShowButtons()
        guard sender.tag > 0 && sender.tag <= 8 else { return } // just in case
        setupActiveBoozeUp(drink: sender.tag, description: nil)
    }
    
    func hideOrShowButtons() {
        isButtonsHidden = !isButtonsHidden
        for drinkBtn in checkInWithDrinks {
            UIView.animate(withDuration: 0.5, animations: {
                drinkBtn.alpha = self.isButtonsHidden ? 0 : 1
            })
            drinkBtn.isUserInteractionEnabled = !isButtonsHidden
        }
    }
    
    // MARK: -
    // MARK: DescriptionViews setup
    
    func descriptionViewAppearance(buttonTag: Int) {
        setupDescriptionTextView()
        setupDescriptionButton(buttonTag)
        
        animateIn()
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
        descriptionTextView.text = ""
    }
    
    func setupDescriptionButton(_ tag: Int) {
        sendButton.tag = tag
        sendButton.titleLabel?.textAlignment = .center
    }
    
    // MARK: -
    // MARK: Create Markers methods
    
    func parseDrunkParties(result: Results) {
        markersArray = result
            .compactMap { Mapper<BoozeUp>().map(JSONObject: $0) }
            .compactMap { setupMapMarkerWith($0) }
        
        mapView.clear()
        
        currentMarker?.map = mapView
        for marker in markersArray {
            marker.map = mapView
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
        }
        marker.tracksInfoWindowChanges = true
        
        return marker
    }
    
    // MARK: -
    // MARK: Setup local BoozeUp
    
    func setupActiveBoozeUp(drink: Int?, description: String?) {
        var parameters = [String:Any]()
        if let marker = currentMarker {
            parameters = createParametersForRequest(drink: drink ?? Int(), latitude: marker.position.latitude, longitude: marker.position.longitude, description: description)
        } else {
            startUpdateLocation()
            parameters = createParametersForRequest(drink: drink ?? Int(), latitude: (userCoordinates?.latitude) ?? Double(), longitude: (userCoordinates?.longitude) ?? Double(), description: description)
        }
        
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
            removeCurrentMarker()
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: -
// MARK: - GMSMapViewDelegate

extension LocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isButtonsHidden {
            currentMarker = GMSMarker(position: coordinate)
            currentMarker?.map = mapView
        } else {
            removeCurrentMarker()
        }
        
        hideOrShowButtons()
    }
}

// MARK: -
// MARK: - Protocol Conformance | CoachMarksControllerDataSource

extension LocationViewController: CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.checkInButton)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.checkInWithDrinks[0])
        case 2:
            return coachMarksController.helper.makeCoachMark(for: self.descriptionView)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
        
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int,
                              madeFrom coachMark: CoachMark) ->
        (bodyView: CoachMarkBodyView,
        arrowView: CoachMarkArrowView?) {
            
            let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
            
            switch(index) {
            case 0:
                coachViews.bodyView.hintLabel.text = Configuration.CoachMarkText.checkInButtonText
                coachViews.bodyView.nextLabel.text = Configuration.CoachMarkText.nextButtonText
            case 1:
                coachViews.bodyView.hintLabel.text = Configuration.CoachMarkText.checkInWithDrinksText
                coachViews.bodyView.nextLabel.text = Configuration.CoachMarkText.nextButtonText
            case 2:
                coachViews.bodyView.hintLabel.text = Configuration.CoachMarkText.descriptionViewText
                coachViews.bodyView.nextLabel.text = Configuration.CoachMarkText.nextButtonText
            default: break
            }
            
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
