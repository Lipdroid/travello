//
//  SavedVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/14/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Firebase
class SavedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var trips = [CarObject]()
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        getAllSavedData()    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell") as? SavedCell{
            if let trip = self.trips[indexPath.row] as? CarObject{
                cell.updateViews(carObj: trip)
                return cell;
            }else{
                return SavedCell()
            }
        }else{
            return SavedCell()
        }
    }
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.1 and below
        return 226
    }
    
    private func getAllSavedData(){
        DADataService.instance.REF_SAVE.observe(.value, with: {(snapshot) in
            print("BrowseVC: finish getting car trip data")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("trips count:\(snapshots.count)")
                for snap in snapshots{
                    if let trip_snap = snap.value as? Dictionary<String, AnyObject>{
                        if let trip = self.parseTripSnap(tripSnapDict: trip_snap) as? CarObject{
                            if(trip.liked == 1){
                                self.trips.append(trip)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
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

}
