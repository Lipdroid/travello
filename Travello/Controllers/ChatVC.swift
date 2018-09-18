//
//  ChatVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/17/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var roomID:String?
    var idReceiver:String?
    var messages = [MessageObject]()
    @IBOutlet var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet var message_txt: UITextField!
    @IBOutlet var title_lbl: UILabel!

    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    var mUserObj: UserObject?
    var recieverObj: UserObject?
    @IBOutlet weak var bottomLayoout: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 600.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        
        self.tableViewScrollToBottom(animated: true)
        
        if let title_txt = recieverObj?.name{
            title_lbl.text = title_txt
        }
        //get the current user
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            //get the user data from firebase
            DADataService.instance.getUserFromFirebaseDB(uid: uid){
                (response) in
                if let user = response as? UserObject{
                    self.mUserObj = user
                    //get all chat from room or create the room
                    self.getAllFromRoom(roomID: self.roomID!)
                }
            }
        } else {
            //User Not logged in
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func getAllFromRoom(roomID: String){
        DADataService.instance.REF_MESSAGE.child(roomID).observe(.value, with: {(snapshot) in
            print("ChatVC: finish getting chat data")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("trips count:\(snapshots.count)")
                self.messages.removeAll()
                for snap in snapshots{
                    if let message_snap = snap.value as? Dictionary<String, AnyObject>{
                        if let message = self.parseMessageSnap(snap: message_snap) as? MessageObject{
                            self.messages.append(message)
                        }
                    }
                    self.tableView.reloadData()
                    self.tableViewScrollToBottom(animated: true)
                }
            }
        })
    }
    
    private func parseMessageSnap(snap: Dictionary<String, AnyObject>)->MessageObject{
        let idSender = snap["idSender"] as? String ?? ""
        let idReceiver = snap["idReceiver"] as? String ?? ""
        let timestamp = snap["timestamp"] as? Double ?? 0
        let text = snap["text"] as? String ?? ""
        //old android version doesnot have provider so check
        //provider available or not
        //if not available just set an empty string
        let messageObj = MessageObject(idSender: idSender, idReceiver: idReceiver, timestamp: timestamp, text: text)
        return messageObj
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 300
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    @IBAction func afterClickSend(_ sender: Any) {
        if let message = message_txt.text{
            if message != ""{
                //send it
                let currentTimeInMiliseconds = getCurrentMillis()
                let messageObj = MessageObject(idSender: (mUserObj?.id)!, idReceiver: idReceiver!, timestamp: Double(currentTimeInMiliseconds), text: message)
                DADataService.instance.createMessage(roomID: roomID!, messageObj: messageObj)
                message_txt.text = ""
            }
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = messages[indexPath.row] as? MessageObject{
            if(item.idSender == mUserObj?.id){
                if let cell = tableView.dequeueReusableCell(withIdentifier: "userChatCell", for: indexPath) as? UserChatCell{
                    if let item = messages[indexPath.row] as? MessageObject{
                        cell.configureCell( chat: item)
                        return cell
                    }
                    return UserChatCell()
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatCell{
                    if let item = messages[indexPath.row] as? MessageObject{
                        cell.configureCell(sender: recieverObj!, chat: item)
                        return cell
                    }
                    return ChatCell()
                }
            }
        }
        return UITableViewCell()
    }
    

    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}
