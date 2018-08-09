//
//  PostVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/7/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import iOSDropDown
import DatePickerDialog
import GoogleMaps

class PostVC: UIViewController {
    @IBOutlet weak var from_address_dropdown: DropDown!
    @IBOutlet weak var to_address_dropdown: DropDown!
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var details: FormTextField!
    @IBOutlet weak var gas_fare: FormTextField!
    @IBOutlet weak var seat: FormTextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_date: UIButton!
    var mUserObj: UserObject! = nil

    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var fromLocation: CLLocationCoordinate2D?
    var toLocation: CLLocationCoordinate2D?
    
    var from_city_txt: String = "София"
    var to_city_txt: String = "София"
    
    @IBAction func afterClickSubmit(_ sender: Any) {
        //request to firebase
        let date_txt = date.text!
        let seats_txt = seat.text!
        let gas_fare_txt = gas_fare.text!
        let detail_txt = details.text!
        
        if date_txt == ""{
            Toast.show(message: "Please Select Date", controller: self)
            return
        }
        if seats_txt == ""{
            Toast.show(message: "Please Set Seat", controller: self)
            return
        }
        if gas_fare_txt == ""{
            Toast.show(message: "Please Set Gas Fare", controller: self)
            return
        }
        if detail_txt == ""{
            Toast.show(message: "Please Set Details", controller: self)
            return
        }
        
        let carObj = CarObject(available_seats: seats_txt, dates: date_txt, description: detail_txt, destination: to_city_txt, email: mUserObj.email!, gas_fare: gas_fare_txt, id: mUserObj.id!, image: mUserObj.imageUrl!, is_plan_a_trip: "false", liked: "0", name: mUserObj.name!, origin: from_city_txt, phone_no:mUserObj.phoneNumber!, rating: "", user_id: mUserObj.id!, usertype: "normal")
        //post the carObject
        DADataService.instance.createFirebaseDBCar(uid: mUserObj.id!,carObject: carObj)
        //Show success message
        Toast.show(message: "Successfully Registered", controller: self)
    }
    @IBAction func afterClickDate(_ sender: Any) {
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: UIColor(hexColor: "26ae90"),
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        datePicker.show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.date.text = formatter.string(from: dt)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropdowns()
        //round the buttons
        btn_date.layer.cornerRadius = 15
        btn_submit.layer.cornerRadius = 15
        scrollView.resizeScrollViewContentSize()
        //zoom to bulgaria
        self.googleMap.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: BULGARIA_LAT,longitude: BULGARIA_LNG), zoom: Float(MAP_ZOOM_LEVEL), bearing: 0, viewingAngle: 0)
        //set todays date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let resultDate = formatter.string(from: currentDate)
        date.text = resultDate



    }
    
    private func setUpDropdowns(){
        // The list of array to display. Can be changed dynamically
        from_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        //get location from string city name
        from_address_dropdown.didSelect{
            (selectedText , index ,id) in
            self.from_city_txt = selectedText;
            self.getCoordinate(addressString: self.from_city_txt){
                location,error in
                if error != nil{
                    return
                }
                if(location.latitude != 0 && location.longitude != 0){
                    //zoom to that location
                    self.googleMap.camera = GMSCameraPosition(target: location, zoom: Float(MAP_ZOOM_LEVEL), bearing: 0, viewingAngle: 0)
                    self.fromLocation = location
                }
                
            }
            
            
        }
        
        // The list of array to display. Can be changed dynamically
        to_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        to_address_dropdown.didSelect{
            (selectedText , index ,id) in
            self.to_city_txt = selectedText;
            self.getCoordinate(addressString: self.to_city_txt){
                location,error in
                if error != nil{
                    return
                }
                if(location.latitude != 0 && location.longitude != 0){
                    //zoom to that location
                    self.googleMap.camera = GMSCameraPosition(target: location, zoom: Float(MAP_ZOOM_LEVEL), bearing: 0, viewingAngle: 0)
                    self.toLocation = location
                    self.googleMap.drawPolygon(from: self.fromLocation!, to: self.toLocation!)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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

extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}
extension UIColor {
    convenience init(hexColor: String) {
        let scannHex = Scanner(string: hexColor)
        var rgbValue: UInt64 = 0
        scannHex.scanLocation = 0
        scannHex.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
}
