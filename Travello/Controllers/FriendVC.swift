//
//  FriendVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/13/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
class FriendVC: UIViewController,IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    var users = [UserObject]()
    var selectedItem: UserObject?
    var mUserObj: UserObject?
    var friends = [String]()
    var roomID:String?
    var idReceiver:String?

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "",image: UIImage(named:"ic_tab_person"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.addSubview(self.refreshControl)
        
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
        
        if ISFROM_CHAT{
            header.isHidden = false
        }else{
            header.isHidden = true
        }

    }
    func getFriendsByUserID(uid: String){
        DADataService.instance.REF_FRIEND.child(uid).observe(.value, with: {(snapshot) in
            print("FriendVC: getting all friends Data")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("friends count:\(snapshots.count)")
                self.friends.removeAll()
                for snap in snapshots{
                    if let friend_snap = snap.value as? String{
                        self.friends.append(friend_snap)
                    }
                }
                self.getAllFriendsData(friendsIds: self.friends)

            }
        })
    }
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func getAllFriendsData(friendsIds: [String])
    {
        users.removeAll()
        for id in friendsIds{
            DADataService.instance.getUserFromFirebaseDB(uid: id){
                (response) in
                if let user = response as? UserObject{
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = users[indexPath.row]
        //get the room id
        if let currentUserID = mUserObj?.id, let friendID = selectedItem?.id{
            if ((currentUserID.compare(friendID).rawValue) > 0){
                roomID = "\(friendID)\(currentUserID)".toBase64()!
                print(roomID ?? "Can not parse roomid")
            }else{
                roomID = "\(currentUserID)\(friendID)".toBase64()!
                print(roomID ?? "Can not parse roomid")
            }
            idReceiver = selectedItem?.id
            //perform segue
            performSegue(withIdentifier: Constants.FRIENDS_TO_CHAT, sender: nil)
        }
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getFriendsByUserID(uid: (self.mUserObj?.id)!)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.FRIENDS_TO_CHAT{
            if let dest: ChatVC = segue.destination as? ChatVC{
                dest.roomID = self.roomID
                dest.idReceiver = self.idReceiver
                dest.recieverObj = selectedItem
            }
        }
    }
}
