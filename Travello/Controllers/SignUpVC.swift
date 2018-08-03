//
//  SignUpVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/30/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    var mUserObj: UserObject! = nil

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var age: UITextField!
    
    @IBAction func goToLoginPage(_ sender: Any) {
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
    
    @IBAction func afterClickSignUp(_ sender: Any) {
        let email_txt = email.text!
        let password_txt = password.text!
        
        if email_txt == ""{
            //please put email address
            Toast.show(message: "Enter email address!", controller: self)
            return
        }
        if password_txt == ""{
            //please put password
            Toast.show(message: "Enter password!", controller: self)
            return
        }
        if password_txt.count < 6{
            Toast.show(message: "Password too short, enter minimum 6 characters!", controller: self)
            return
        }
        
        requestrequestFirebaseToRegister(email: email_txt,password: password_txt)
    }
    
    func requestrequestFirebaseToRegister(email: String,password: String){
        Progress.sharedInstance.showLoading()
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (authResult, error) in
            if(error != nil){
                Progress.sharedInstance.dismissLoading()
                return
            }
            
            if let uid = authResult?.uid{
                //create the user
                self.mUserObj = UserObject(address: self.address.text!, age: self.age.text!, avata: "", email: email, id: uid, imageUrl: "", name: self.name.text!, phoneNumber: self.phone.text!,provider: Constants.EMAIL_PROVIDER)
                //now push to firebase database
                DADataService.instance.createFirebaseDBUser(uid: (FIRAuth.auth()?.currentUser?.uid)!, userObject: self.mUserObj!)
                //dismiss loading
                Progress.sharedInstance.dismissLoading()
                //successfully registered
                Toast.show(message: "Successfully registered!", controller: self)
                self.go_to_main_page()
            }
        }
    }
    func go_to_main_page(){
        //finish itself
        self.dismiss(animated: true, completion: nil)
        //segue to main page
        performSegue(withIdentifier: Constants.SIGNUP_TO_MAINVIEW, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SIGNUP_TO_MAINVIEW{
            if let dest: MainVC = segue.destination as? MainVC{
                dest.mUserObj = self.mUserObj
            }
        }
    }

}
