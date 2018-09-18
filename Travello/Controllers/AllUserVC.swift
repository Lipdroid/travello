//
//  AllUserVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/13/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
class AllUserVC: UIViewController,IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    var users = [UserObject]()
    var friends = [String]()
    var selectedItem: UserObject?
    var mUserObj: UserObject?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "",image: UIImage(named:"ic_tab_group"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        //get the current user
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            //get the user data from firebase
            DADataService.instance.getUserFromFirebaseDB(uid: uid){
                (response) in
                if let user = response as? UserObject{
                    self.mUserObj = user
                    self.getFriendsByUserID(uid: (self.mUserObj?.id)!)
                }
            }
        } else {
            //User Not logged in
            dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = users[indexPath.row]
        addFriend()
        users.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        Toast.show(message: "Successfully Added As a Friend", controller: self)
    }
    
    private func addFriend(){
        DADataService.instance.addToFriendList(currentUserID: (mUserObj?.id)!, addedUserID: (selectedItem?.id)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriendCell") as? UserFriendCell{
            if let user = self.users[indexPath.row] as? UserObject{
                cell.updateCell(userData: user)
                return cell;
            }else{
                return UserChatCell()
            }
        }else{
            return UserChatCell()
        }
    }
    private func getAllUserData(){
        DADataService.instance.REF_USER.observe(.value, with: {(snapshot) in
            print("AllUserVC: finish getting users data")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("user count:\(snapshots.count)")
                self.users.removeAll()
                for snap in snapshots{
                    if let user_snap = snap.value as? Dictionary<String, AnyObject>{
                        if let user = self.parseUserSnap(snap: user_snap) as? UserObject{
                            if(!self.friends.contains(user.id!) && user.id! != self.mUserObj?.id){
                                self.users.append(user)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    private func parseUserSnap(snap: Dictionary<String, AnyObject>)->UserObject{
        let address = snap["address"] as? String ?? ""
        let age = snap["age"] as? String ?? ""
        let avata = snap["avata"] as? String ?? ""
        let email = snap["email"] as? String ?? ""
        let imageUrl = snap ["imageUrl"] as? String ?? ""
        let name = snap ["name"] as? String ?? ""
        let phoneNumber = snap ["phoneNumber"] as? String ?? ""
        let provider = snap ["provider"] as? String ?? ""
        let uid = snap ["id"] as? String ?? ""

        //old android version doesnot have provider so check
        //provider available or not
        //if not available just set an empty string
        let mUserObj = UserObject(address: address as! String,age: age as! String,avata: avata as! String,email: email as! String,id: uid as! String,imageUrl: imageUrl as! String,name: name as! String,phoneNumber: phoneNumber as! String,provider: provider as! String)
        return mUserObj
    }
    
    func getFriendsByUserID(uid: String){
        DADataService.instance.REF_FRIEND.child(uid).observe(.value, with: {(snapshot) in
            print("AllFriendVC: getting all friends Data")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("friends count:\(snapshots.count)")
                self.friends.removeAll()
                for snap in snapshots{
                    if let friend_snap = snap.value as? String{
                        self.friends.append(friend_snap)
                    }
                }
                
            }
            self.getAllUserData()
        })
    }

}
