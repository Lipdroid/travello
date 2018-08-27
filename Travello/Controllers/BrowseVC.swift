//
//  BrowseVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/7/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown

class BrowseVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CarcellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var trips = [CarObject]()
    var selectedTrip: CarObject?
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func afterClickSearch(_ sender: Any) {
        getAllTripData()
    }
    private func filter(){
        if trips.count > 0{
            var filter_trips = [CarObject]()
            for i in 0 ..< trips.count {
                let trip = trips[i]
                if trip.origin == from_city_txt{
                    filter_trips.append(trip)
                }
            }
            trips = filter_trips
            tableView.reloadData()
        }
    }
    @IBOutlet weak var from_address_dropdown: DropDown!
    @IBOutlet weak var to_address_dropdown: DropDown!
    var from_city_txt: String = "София"
    var to_city_txt: String = "София"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropdowns()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTrip = trips[indexPath.row]
        //perform segue
        performSegue(withIdentifier: Constants.SHOW_TO_DETAILS, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SHOW_TO_DETAILS{
            if let dest: TripDetailsVC = segue.destination as? TripDetailsVC{
                dest.trip = self.selectedTrip
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as? CarCell{
            if let trip = self.trips[indexPath.row] as? CarObject{
                cell.updateViews(carObj: trip)
                cell.carcellDelegate = self
                return cell;
            }else{
                return CarCell()
            }
        }else{
            return CarCell()
        }
    }
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.1 and below
        return 226
    }
    
    private func getAllTripData(){
        DADataService.instance.REF_CAR.observe(.value, with: {(snapshot) in
            print("BrowseVC: finish getting car trip data")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("trips count:\(snapshots.count)")
                self.trips.removeAll()
                for snap in snapshots{
                    if let trip_snap = snap.value as? Dictionary<String, AnyObject>{
                        if let trip = self.parseTripSnap(tripSnapDict: trip_snap) as? CarObject{
                            self.trips.append(trip)
                        }
                    }
                }
                self.filter()
            }
        })
    }
    
    private func parseTripSnap(tripSnapDict: Dictionary<String, AnyObject>)->CarObject{
        var carObject = CarObject(available_seats: "", dates: "", description: "", destination: "", email: "", gas_fare: "", id: "", image: "", is_plan_a_trip: false, liked: 0, name: "", origin: "", phone_no: "", rating: "", user_id: "", usertype: "")
        
        if let available_seats = tripSnapDict["avaiable_seats"] as? String{
            carObject.available_seats = available_seats
        } else{
            return carObject
        }
        if let dates = tripSnapDict["dates"] as? String{
            carObject.dates = dates
        } else{
            return carObject
        }
        if let description = tripSnapDict["description"] as? String {
            carObject.description = description
        }else{
            return carObject
        }
        if let destination = tripSnapDict["destination"] as? String{
            carObject.destination = destination
        } else{
            return carObject
        }
        if let email = tripSnapDict["email"] as? String{
            carObject.email = email
        } else{
            return carObject
        }
        if let gas_fare = tripSnapDict["gas_fare"] as? String {
            carObject.gas_fare = gas_fare
        }else{
            return carObject
        }
        if let id = tripSnapDict["id"]  as? String {
            carObject.id = id
        }else{
            return carObject
        }
        if let image = tripSnapDict["image"] as? String {
            carObject.image = image
        }else{
            return carObject
        }
        if let is_plan_a_trip = tripSnapDict["is_plan_a_trip"] as? Bool{
            carObject.is_plan_a_trip = is_plan_a_trip
        } else{
            return carObject
        }
        if let liked = tripSnapDict["liked"] as? Int {
            carObject.liked = liked
        }else{
            return carObject
        }
        if let name = tripSnapDict["name"] as? String{
            carObject.name = name
        } else{
            return carObject
        }
        if let origin = tripSnapDict["origin"] as? String{
            carObject.origin = origin
        } else{
            return carObject
        }
        if let phone_no = tripSnapDict["phone_no"] as? String {
            carObject.phone_no = phone_no
        }else{
            return carObject
        }
        if let rating = tripSnapDict["rating"] as? String {
            carObject.rating = rating
        }else{
            return carObject
        }
        if let user_id = tripSnapDict["user_id"] as? String {
            carObject.user_id = user_id
        }else{
            return carObject
        }
        if let usertype = tripSnapDict["usertype"] as? String {
            carObject.usertype = usertype
        }else{
            return carObject
        }
        return carObject
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
    func didLikeTapped(carObj: CarObject) {
        //TODO: update the item
        if let index = trips.index(where: {$0.id == carObj.id}) {
            // do something with index
            if(carObj.liked == 1){
                trips[index].liked = 0
            }else{
                trips[index].liked = 1
            }
            //TODO: update the imageview
            tableView.reloadData()
            //TODO: update the car objcet in firebase
            DADataService.instance.updateFirebaseDBCarLike(uid: trips[index].id,carObject: trips[index])
            //TODO: add it to save
            DADataService.instance.createFirebaseDBSave(uid: trips[index].id,carObject: trips[index])
        }
        
    }
    
    func didCallTapped(phoneNo: String) {
        if let url = URL(string: "tel://\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

    }
    
    
}
