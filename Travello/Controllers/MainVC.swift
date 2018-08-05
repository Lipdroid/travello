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
    var mUserObj: UserObject! = nil
    @IBOutlet weak var left_nav_menu: UIView!
    @IBOutlet weak var left_nav_leading_constraint: NSLayoutConstraint!
    var left_nav_view_isShown = false
    @IBOutlet weak var tranparent_overlay: UIVisualEffectView!
    @IBAction func pressed_outside_navDrawer(_ sender: Any) {
        toggleLeftMenu()
    }
    @IBAction func btn_logout_pressed(_ sender: Any) {
        do{
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

        // Do any additional setup after loading the view.
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
            left_nav_leading_constraint.constant = -280
            
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

}
