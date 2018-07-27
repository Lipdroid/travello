//
//  ViewController.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/26/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //get the current app version
        //if current version is equal with prev version then do nothing
        //else show terms pop up
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String{
            //Check if version value set in userDefaults
            if let prev_version = UserDefaults.standard.object(forKey: Constants.VERSION) as? String{
                if version == prev_version{
                    //go to app
                }else{
                    //show a dialog pop up
                    let alert = TermsAlertView()
                    alert.show(animated: true)
                }
            }else{
                //show a dialog pop up
                let alert = TermsAlertView()
                alert.show(animated: true)
            }
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

