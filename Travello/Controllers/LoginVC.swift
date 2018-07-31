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

class LoginVC: UIViewController,FBSDKLoginButtonDelegate {
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var btn_or: UIButton!
    @IBOutlet weak var btn_fbLogin: FBSDKLoginButton!
    @IBOutlet weak var password_field: UITextField!
    var mUserObj: UserObject! = nil
    
    
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
        btn_fbLogin.readPermissions = ["public_profile", "email", "user_friends"]

        self.btn_fbLogin.delegate = self

        if let user = FIRAuth.auth()?.currentUser {
                let uid = user.uid
                //get the user data from firebase
                DADataService.instance.getUserFromFirebaseDB(uid: uid){
                    (response) in
                    if let user = response as? UserObject{
                        self.mUserObj = user
                        //go to main page
                        self.go_to_main_page()
                    }
            }
        } else {
            //User Not logged in
        }
    
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
    
            if let uid = user?.uid{
                //get the user data from firebase
                DADataService.instance.getUserFromFirebaseDB(uid: uid){
                    (response) in
                    if let user = response as? UserObject{
                        self.mUserObj = user
                        //go to main page
                        self.go_to_main_page()
                    }
                }
            }
        }
    }
    
    func go_to_main_page(){
        performSegue(withIdentifier: Constants.LOGINVIEW_TO_MAINVIEW, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.LOGINVIEW_TO_MAINVIEW{
            if let dest: MainVC = segue.destination as? MainVC{
                dest.mUserObj = self.mUserObj
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // Navigate to other view
            //Login successfull
            if let token = FBSDKAccessToken.current() {
                let accessToken = token.tokenString
                // USE YOUR TOKEN HERE
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //logout
    }
}

