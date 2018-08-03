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
        checkForVersion()
        //make the OR button round
        btn_or.layer.cornerRadius = 0.5 * btn_or.bounds.size.width
        btn_or.clipsToBounds = true
        
        //change fb button text
        let buttonText = NSAttributedString(string: "Continue With Facebook")
        btn_fbLogin.setAttributedTitle(buttonText, for: .normal)
        btn_fbLogin.readPermissions = ["public_profile", "email"]

        self.btn_fbLogin.delegate = self

        if let user = FIRAuth.auth()?.currentUser {
                Progress.sharedInstance.showLoading()
                let uid = user.uid
                //get the user data from firebase
                DADataService.instance.getUserFromFirebaseDB(uid: uid){
                    (response) in
                    Progress.sharedInstance.dismissLoading()
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
        Progress.sharedInstance.showLoading()
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if(error != nil){
                Progress.sharedInstance.dismissLoading()
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
                    Progress.sharedInstance.dismissLoading()
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
        //clear the fields
        email_field.text = ""
        password_field.text = ""
        //perform segue
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
            //Login successfull
            if let token = FBSDKAccessToken.current() {
                guard let accessToken = token.tokenString else
                {
                    return
                }
                // USE YOUR TOKEN HERE
                Progress.sharedInstance.showLoading()
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
                FIRAuth.auth()?.signIn(with: credential, completion: { (User, error) in
                    if(error != nil){
                        Progress.sharedInstance.dismissLoading()
                        Toast.show(message: "Something went wrong\(String(describing: error?.localizedDescription))", controller: self)
                        print(error ?? "")
                        return
                    }
                    self.getFBUserData()
                    print("facebook authentication complete through firebase")
                })
                
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result!)
                    if let dict = result as? Dictionary<String,AnyObject>{
                        if let authId = FIRAuth.auth()?.currentUser?.uid{
                            self.mUserObj = UserObject(authId: authId,dict: dict)
                            DADataService.instance.createFirebaseDBUser(uid: (FIRAuth.auth()?.currentUser?.uid)!, userObject: self.mUserObj!)
                            Progress.sharedInstance.dismissLoading()
                            self.go_to_main_page()
                        }else{
                            Progress.sharedInstance.dismissLoading()
                            print("no uid found from firebase current user for fb")
                        }
                        
                    }
                    
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //logout
    }
    
    func checkForVersion(){
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
        }else{
            //anything wrong with getting bundle from info.plist
            //show a dialog pop up
            print("can not get bundle for info.plish")
        }
    }
}

