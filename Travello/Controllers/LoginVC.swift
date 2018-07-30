//
//  ViewController.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/26/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var btn_or: UIButton!
    @IBOutlet weak var btn_fbLogin: FBSDKLoginButton!
    @IBOutlet weak var password_field: UITextField!

    
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

    @IBAction func login_btn_pressed(_ sender: Any) {
         let email = email_field.text!
         let password = password_field.text!
        
        if email == ""{
            //please put email address
            Toast.show(message: "Please insert email address", controller: self)
            return
        }
        if password == ""{
            //please put password
            Toast.show(message: "Please insert password", controller: self)
            return
        }
        requestFirebaseToLogin(email: email,password: password)
    }
    
    private func requestFirebaseToLogin(email: String,password: String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if(error != nil){
                if password.count < 6{
                    Toast.show(message: "Паролата е твърде кратка, въведете минимум 6 знака!", controller: self)
                }else{
                   Toast.show(message: "Удостоверяването не бе успешно, проверете имейла и паролата си или се регистрирайте", controller: self)
                }
                return
            }
            
            //no error so successfully login
            Toast.show(message: "Success", controller: self)

            
        }
    }
}

