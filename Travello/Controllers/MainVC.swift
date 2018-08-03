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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
