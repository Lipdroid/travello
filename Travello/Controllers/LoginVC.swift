//
//  ViewController.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/26/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet weak var btn_or: UIButton!
    @IBOutlet weak var btn_fbLogin: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //get the current app version
        //if current version is equal with prev version then do nothing
        //else show terms pop up
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String{
            //Check if version value set in userDefaults
            if let prev_version = UserDefaults.standard.object(forKey: Constants.VERSION) as? String{
                if version != prev_version {
                    //show a dialog pop up
                    let alert = TermsAlertView()
                    alert.show(animated: true)
                }
            }else{
                //for the first time
                //show a dialog pop up
                let alert = TermsAlertView()
                alert.show(animated: true)
            }
        }
        
        //make the OR button round
        btn_or.layer.cornerRadius = 0.5 * btn_or.bounds.size.width
        btn_or.clipsToBounds = true
        
        //change fb button text
        let buttonText = NSAttributedString(string: "Continue With Facebook")
        btn_fbLogin.setAttributedTitle(buttonText, for: .normal)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

