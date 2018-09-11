//
//  MainVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/31/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class MainVC: UIViewController {
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var avatar: CircleImageView!
    
    @IBOutlet weak var btn_post: UIButton!
    @IBOutlet weak var btn_browse: UIButton!
    
    var mUserObj: UserObject! = nil
    @IBOutlet weak var left_nav_menu: UIView!
    @IBOutlet weak var left_nav_leading_constraint: NSLayoutConstraint!
    var left_nav_view_isShown = false
    @IBOutlet weak var tranparent_overlay: UIVisualEffectView!
    
    @IBOutlet weak var btn_logout: UIStackView!
    @IBOutlet weak var btn_home: UIStackView!
    @IBOutlet weak var btn_rides: UIStackView!
    @IBOutlet weak var btn_trip_plan: UIStackView!
    @IBOutlet weak var btn_save: UIStackView!
    @IBOutlet weak var btn_chat: UIStackView!
    @IBOutlet weak var btn_friends: UIStackView!
    
    @IBAction func pressed_outside_navDrawer(_ sender: Any) {
        toggleLeftMenu()
    }
    @IBAction func btn_logout_pressed(_ sender: Any) {
        do{
            toggleLeftMenu()
            //logout firebase user
            try FIRAuth.auth()?.signOut()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        //if fbUser
        if (FBSDKAccessToken.current()) != nil
        {
            FBSDKLoginManager().logOut()

        }
        //dismiss page
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nav_menu_icon_pressed(_ sender: Any) {
        toggleLeftMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set user data in the drawer
        setUserData()
        //set tap recognizers in the drawer
        addGestureToMenuItems()
        //rounded the corners on the buttons
        btn_post.layer.cornerRadius = 5
        btn_browse.layer.cornerRadius = 5
    }
    
    private func setUserData(){
        if let name = mUserObj.name{
            name_lbl.text = name
        }
        if let email = mUserObj.email{
            email_lbl.text = email
        }
        //show image from image url
        if let imageUrl = mUserObj.imageUrl{
            avatar.imageFromServerURL(urlString: imageUrl, defaultImage: "default_avata")
        }
    }
    
    private func addGestureToMenuItems(){
        btn_home.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_home_pressed)))
        btn_rides.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_rides_pressed)))
        btn_trip_plan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_trip_plan_pressed)))
        btn_friends.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_friends_pressed)))
        btn_chat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_chat_pressed)))
        btn_save.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_save_pressed)))
        btn_logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btn_logout_pressed)))
    }
    
    @objc func btn_home_pressed(){
        //close menu
        toggleLeftMenu()
    }
    @objc func btn_rides_pressed(){
        //close menu
        toggleLeftMenu()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "browseVC") as! BrowseVC
        self.present(newViewController, animated: true, completion: nil)

    }
    @objc func btn_trip_plan_pressed(){
        //close menu
        toggleLeftMenu()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "tripPlan") as! PlanTripVC
        self.present(newViewController, animated: true, completion: nil)
        
    }
    @objc func btn_friends_pressed(){
        //close menu
        toggleLeftMenu()
    }
    @objc func btn_chat_pressed(){
        //close menu
        toggleLeftMenu()
    }
    @objc func btn_save_pressed(){
        //close menu
        toggleLeftMenu()
        //perform segue
        performSegue(withIdentifier: Constants.MAINVIEW_TO_SAVEVIEW, sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc private func toggleLeftMenu(){
        if !left_nav_view_isShown{
            left_nav_leading_constraint.constant = 0
            left_nav_menu.layer.shadowOpacity = 1
            left_nav_menu.layer.shadowRadius = 6.0
            tranparent_overlay.isHidden = false
            
        }else{
            left_nav_leading_constraint.constant = -300
            
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
            
        }){(true) in
            if !self.left_nav_view_isShown{
                self.left_nav_menu.layer.shadowOpacity = 0
                self.tranparent_overlay.isHidden = true
            }else{
                //self.left_nav_btn_view.isHidden = true
                
            }
            
        }
        
        left_nav_view_isShown = !left_nav_view_isShown
    }
 
    @IBAction func after_click_post(_ sender: Any) {
    }
    
    @IBAction func after_click_browse(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.MAINVIEW_TO_POSTVIEW{
            if let dest: PostVC = segue.destination as? PostVC{
                dest.mUserObj = self.mUserObj
            }
        }
    }
}
