//
//  TripDetailsVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/27/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos

class TripDetailsVC: UIViewController {
    var trip: CarObject! = nil
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pro_image: CircleImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var seats: FormTextField!
    @IBOutlet weak var gas_fare: FormTextField!
    @IBOutlet weak var details: FormTextField!
    @IBOutlet weak var rating: CosmosView!
    
    @IBOutlet weak var googleMap: GMSMapView!
    var fromLocation: CLLocationCoordinate2D?
    var toLocation: CLLocationCoordinate2D?
    
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.resizeScrollViewContentSize()
            setUserData()
    }
    
    private func setUserData(){
        name.text = trip.name
        email.text = trip.email
        if(trip.phone_no == nil || trip.phone_no == ""){
            phone.isHidden = true
        }else{
            phone.isHidden = false
            phone.text = trip.phone_no
        }
        from.text = trip.origin
        to.text = trip.destination
        date.text = trip.dates
        seats.text = trip.available_seats
        gas_fare.text = trip.gas_fare
        details.text = trip.description
        // Change the cosmos view rating
        if let rate:Int = Int(trip.rating){
            rating.rating = Double(rate)
        }
        //show image from image url
        if let imageUrl = trip.image{
            if(imageUrl == "" || !imageUrl.hasPrefix("https")){
                pro_image.image = UIImage(named: "default_avata")
            }else{
                pro_image.imageFromServerURL(urlString: imageUrl, defaultImage: "default_avata")
            }
        }
        
        self.getCoordinate(addressString: trip.origin){
            location,error in
            if error != nil{
                return
            }
            if(location.latitude != 0 && location.longitude != 0){
                //zoom to that location
                self.googleMap.camera = GMSCameraPosition(target: location, zoom: Float(MAP_ZOOM_LEVEL), bearing: 0, viewingAngle: 0)
                self.fromLocation = location
                self.getCoordinate(addressString: self.trip.destination){
                    location,error in
                    if error != nil{
                        return
                    }
                    if(location.latitude != 0 && location.longitude != 0){
                        //zoom to that location
                        self.googleMap.camera = GMSCameraPosition(target: location, zoom: Float(MAP_ZOOM_LEVEL), bearing: 0, viewingAngle: 0)
                        self.toLocation = location
                        if(self.fromLocation != nil && self.toLocation != nil){
                            self.googleMap.drawPolygon(from: self.fromLocation!, to: self.toLocation!)
                        }
                    }
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }

}
