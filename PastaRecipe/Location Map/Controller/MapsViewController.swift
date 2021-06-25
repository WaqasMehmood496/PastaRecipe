//
//  MapsViewController.swift
//  OnSaloon
//
//  Created by Waqas on 16/04/2021.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    //MARK: IBOUTLET'S
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblAddress: UITextField!
    //MARK: VARIABLE'S
    var locationManager = CLLocationManager()
    var location = LocationModel()
    var curentPosition: CLLocationCoordinate2D!
    var zoomLevel: Float = 18.0
    var delagate:PassDataDelegate?
    var isLocationGet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGoogleMapFunctionality()
        self.setupGoogleMapStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: IBACTION'S
    @IBAction func doneBtnPressed(_ sender:Any){
        delagate?.passCurrentLocation(data: self.location)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- HELPING METHOD'S
extension MapsViewController{
    // THIS METHOD WILL CHANGE GOOGLE MAP STYLE INTO DARK VIEW
    func setupGoogleMapStyle() {
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    // THIS METHOD WILL GET THE CURRENT LOCATION AND SET THE POINTER TO IT
    func setupGoogleMapFunctionality() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    //THIS METHOD WILL PLACE A MARK ON USER CURRENT LOCATION
    func placeMarkOnGoogleMap(location:CLLocation,address:String) {
        let marker = GMSMarker(position: location.coordinate)
        marker.title = address
        self.lblAddress.text = address
        marker.map = self.mapView
        marker.icon = UIImage(named: "Location")
    }
    // THIS METHOD WILL SAVE USER CURRENT LOCATION DATA INTO OBJECT
    func saveLocationDataInModel(location:CLLocation,address:GMSAddress,userAddress:String) {
        self.location.address_name = address.locality
        self.location.address = userAddress
        self.location.street_address_1 = address.subLocality
        self.location.street_address_2 = address.locality
        self.location.city = address.administrativeArea
        self.location.zipcode = address.postalCode
        self.location.address_lat = location.coordinate.latitude
        self.location.address_lng = location.coordinate.longitude
    }
}

extension MapsViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isLocationGet{
            
        }else{
            self.isLocationGet = true
            let location: CLLocation = locations.last!
            print("Location: \(location)")
            
            self.curentPosition = location.coordinate
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            mapView.camera = camera
            mapView.animate(to: camera)
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(location.coordinate){response , error in
                guard let address: GMSAddress = response?.firstResult()
                else
                {
                    return
                }
                let  v = address.lines!.joined(separator: "\n")
                let marker = GMSMarker(position: location.coordinate)
                marker.title = v
                self.lblAddress.text = v
                marker.map = self.mapView
                
                marker.icon = #imageLiteral(resourceName: "Search Location")
                self.location.address_name = address.locality
                self.location.address = v
                self.location.street_address_1 = address.subLocality
                self.location.street_address_2 = address.locality
                self.location.city = address.administrativeArea
                self.location.zipcode = address.postalCode
                self.location.address_lat = location.coordinate.latitude
                self.location.address_lng = location.coordinate.longitude
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            PopupHelper.alertWithAppSetting(title: "Alert", message: "Please enable your location", controler: self)
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
