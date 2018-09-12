//
//  ChoosePlaceVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/12/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import GoogleMaps
protocol LocationSelected {
    func locationSelectionCompleted(address: String,type: String)
}
class ChoosePlaceVC: UIViewController {
    @IBOutlet weak var selectedAdress: UILabel!
    let TAG = "ChoosePlaceVC"
    let locationManager = CLLocationManager()
    @IBOutlet weak var googleMap: GMSMapView!
    var locationSelected: LocationSelected?
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        NotificationCenter.default.addObserver(self, selector:#selector(checkForLocationPermission), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func afterClickDone(_ sender: Any){
        if(locationSelected != nil){
            if let address = selectedAdress.text{
               locationSelected?.locationSelectionCompleted(address: address,type: type!)
                dismiss(animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func checkForLocationPermission(){
        if (CLLocationManager.locationServicesEnabled())
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                print("\(self.TAG): User disabled Location permisson")
                showAlertForSettings()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                print("\(self.TAG): User enabled Location permission")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                break
            }
            
        }else{
            showAlertForSettings()
        }
    }
    
    private func showAlertForSettings(){
        // create the alert
        let alert = UIAlertController(title: "Alert", message: "Please enable your location service from settings to run this app", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: goToSystemSettings))
        //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToSystemSettings(action: UIAlertAction) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        
    }

}

// MARK: - CLLocationManagerDelegate
//An extension for showing user location
extension ChoosePlaceVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    //locationManager(_:didUpdateLocations:) executes when the location manager receives new location data.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //zoom to current location
            self.googleMap.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: location.coordinate.latitude,longitude: location.coordinate.longitude), zoom: Float(MAP_ZOOM_LEVEL), bearing: 0, viewingAngle: 0)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                var address = ""
                // Location name
                if let locationName = placeMark.name  {
                    print(locationName)
                    address = "\(address) \(locationName),";
                }
                if let subAdministrativeArea = placeMark.subAdministrativeArea  {
                    print(subAdministrativeArea)
                    address = "\(address) \(subAdministrativeArea),";
                }
                
                if let postal = placeMark.postalCode  {
                    print(postal)
                    address = "\(address) \(postal),";
                }
                if let administrativeArea = placeMark.administrativeArea  {
                    print(administrativeArea)
                    address = "\(address) \(administrativeArea),";
                }
                
                // Street address
                if let street = placeMark.thoroughfare {
                    print(street)
                    address = "\(address) \(street),";
                }
                
                // Country
                if let country = placeMark.country {
                    print(country)
                    address = "\(address) \(country)";
                }
                self.selectedAdress.text = address
                self.locationManager.stopUpdatingLocation()
            })
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        print("location changed")
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let centerMapCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(centerMapCoordinate, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            if let placeMark = placemarks?[0]{
                var address = ""
                if let locationName = placeMark.addressDictionary?["Name"] as? String {
                    address += locationName + ", "
                }
                
                // Street address
                if let street = placeMark.addressDictionary?["Thoroughfare"] as? String {
                    address += street + ", "
                }
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? String {
                    address += city + ", "
                }
                
                // Zip code
                if let zip = placeMark.addressDictionary?["ZIP"] as? String {
                    address += zip + ", "
                }
                
                // Country
                if let country = placeMark.addressDictionary?["Country"] as? String {
                    address += country
                }
                
                
                self.selectedAdress.text = address
                self.locationManager.stopUpdatingLocation()
            }
        })
        
    }
}
