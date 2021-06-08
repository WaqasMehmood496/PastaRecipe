//
//  GeoLocationVC.swift
//  PastaRecipe
//
//  Created by moin janjua on 26/09/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import Alamofire
import NVActivityIndicatorView
import LGSideMenuController
import JGProgressHUD
class GeoLocationVC: UIViewController{
  @IBOutlet weak var map: GMSMapView!
  @IBOutlet weak var AntivityIndicationVIew: NVActivityIndicatorView!
  var locationManager = CLLocationManager()
  var mapMarkArray:[MapMarkerModel] = []
  var selectedMarkerData = MapMarkerModel()
  var dataDic:[String:Any]!
  override func viewDidLoad(){
    super.viewDidLoad()
    setupGoogleMap()
    map.delegate = self
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    //setupMap()
  }
}
// MARK: Functions
extension GeoLocationVC {
  func setupMap() {
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
    self.view.addSubview(mapView)
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    marker.title = "Sydney"
    marker.snippet = "Australia"
    marker.map = mapView
  }
  func findMarker(markerTitle:String) {
    for i in mapMarkArray{
      if i.title == markerTitle{
        selectedMarkerData = i
        self.performSegue(withIdentifier: "MarkerDetailSegue", sender: nil)
      }
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "MarkerDetailSegue") {
      let vc = segue.destination as! ShopDetailVC
      vc.mapmarkerObj = selectedMarkerData
    }
  }
}
extension GeoLocationVC{
  func GetAllPlansApi(latitude:String,longitude:String) {
    showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
      hud.show(in: self.view, animated: true)
      if Connectivity.isConnectedToNetwork(){
        self.dataDic = [String:Any]()
        self.callWebService(.homepage, hud: hud)
      }else{
        hud.textLabel.text = "You are not connected to the internet. Please check your connection"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.dismiss(afterDelay: 2, animated: true)
      }
    }
  }
}
extension GeoLocationVC:WebServiceResponseDelegate{
  func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
    let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
    helper.delegateForWebServiceResponse = self
    helper.callWebService()
  }
  func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
    switch url {
    case .homepage:
      if let data = dataDict as? NSArray{
        self.mapMarkArray.removeAll()
        for array in data{
          self.mapMarkArray.append(MapMarkerModel(dic: array as! NSDictionary)!)
        }
      }
      for i in self.mapMarkArray{
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(i.lat)!)!, longitude: CLLocationDegrees(exactly: Double(i.lng)!)!)
        print("location: \(location)")
        let marker = GMSMarker()
        marker.position = location
        marker.snippet = i.title
        marker.map = self.map
        //self.AntivityIndicationVIew.stopAnimating()
      }
      hud.dismiss()
    default:
      hud.dismiss()
    }
  }
}
// MARK:- Google Map Delegates
extension GeoLocationVC: CLLocationManagerDelegate ,GMSMapViewDelegate{
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    findMarker(markerTitle: marker.snippet!)
    return true
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
    map.isMyLocationEnabled = true
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    map.camera = GMSCameraPosition(target: location.coordinate, zoom: 14.0, bearing: 0, viewingAngle: 0)
    // Call Location Api
    //self.GetAllPlansApi(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
    locationManager.stopUpdatingLocation()
  }
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    print(mapView)
  }
}
extension GeoLocationVC{
  func setupGoogleMap() {
    do {
      if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
        self.map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } else {
        NSLog("Unable to find style.json")
      }
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
  }
}
