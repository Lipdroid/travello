//
//  PlanTripVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/11/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import iOSDropDown
import DLRadioButton
import DatePickerDialog

class PlanTripVC: UIViewController,LocationSelected {
    @IBOutlet weak var radioButton: DLRadioButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var from_address_dropdown: DropDown!
    @IBOutlet weak var to_address_dropdown: DropDown!
    var from_city_txt: String = "София"
    var to_city_txt: String = "София"
    @IBOutlet weak var btn_or: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_date: UIButton!
    @IBOutlet weak var details: FormTextField!
    @IBOutlet weak var seat: FormTextField!
    var user_type: String = ""
    var mUserObj: UserObject! = nil
    var locationType = ""
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.resizeScrollViewContentSize()
        
        setUpDropdowns()
        //make the OR button round
        btn_or.layer.cornerRadius = 0.5 * btn_or.bounds.size.width
        btn_or.clipsToBounds = true
        //round the buttons
        btn_date.layer.cornerRadius = 15
        btn_submit.layer.cornerRadius = 15
        //set todays date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let resultDate = formatter.string(from: currentDate)
        date.text = resultDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func afterClickPassenger(_ sender: Any) {
        print("Passenger is pressed")
        user_type = "Пътник"
    }
    @IBAction func afterClickDriver(_ sender: Any) {
        print("driver is pressed")
        user_type = "шофьор"
    }
    
    private func setUpDropdowns(){
        // The list of array to display. Can be changed dynamically
        from_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        //get location from string city name
        from_address_dropdown.didSelect{
            (selectedText , index ,id) in
            self.from_city_txt = selectedText;
            
        }
        
        // The list of array to display. Can be changed dynamically
        to_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        to_address_dropdown.didSelect{
            (selectedText , index ,id) in
            self.to_city_txt = selectedText;
        }
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
    
    @IBAction func afterClickFormLocation(_ sender: Any){locationType = "0"}
    @IBAction func afterClickToLocation(_ sender: Any) {locationType = "1"}

    @IBAction func afterClickSubmit(_ sender: Any) {
        //request to firebase
        let date_txt = date.text!
        let seats_txt = seat.text!
        let detail_txt = details.text!
        
        if user_type == ""{
            Toast.show(message: "Please Select userType", controller: self)
            return
        }
        if date_txt == ""{
            Toast.show(message: "Please Select Date", controller: self)
            return
        }
        if seats_txt == ""{
            Toast.show(message: "Please Set Seat", controller: self)
            return
        }
        
        if detail_txt == ""{
            Toast.show(message: "Please Set Details", controller: self)
            return
        }
        
        let carObj = CarObject(available_seats: seats_txt, dates: date_txt, description: detail_txt, destination: to_city_txt, email: mUserObj.email!, gas_fare: "", id: mUserObj.id!, image: mUserObj.imageUrl!, is_plan_a_trip: true, liked: 0, name: mUserObj.name!, origin: from_city_txt, phone_no:mUserObj.phoneNumber!, rating: "", user_id: mUserObj.id!, usertype: user_type)
        //post the carObject
        DADataService.instance.createFirebaseDBCar(uid: mUserObj.id!,carObject: carObj)
        //Show success message
        Toast.show(message: "Успешно регистриран!", controller: self)
    }
    func locationSelectionCompleted(address: String,type: String) {
        if(type == "0"){
            fromLbl.text = address
            from_city_txt = address
        }else{
            toLbl.text = address
            to_city_txt = address
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.PlAN_TO_MAP{
            if let dest: ChoosePlaceVC = segue.destination as? ChoosePlaceVC{
                dest.locationSelected = self
                dest.type = self.locationType
            }
        }
    }
}
