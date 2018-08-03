//
//  ResetPassVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/30/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Firebase

class ResetPassVC: UIViewController {

    @IBOutlet weak var email_field: UITextField!
    @IBAction func onBackPress(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    @IBAction func afterClickReset(_ sender: Any) {
        let email = email_field.text!
        if(email == ""){
            Toast.show(message: "Enter your registered email id", controller: self)
            return
        }
        Progress.sharedInstance.showLoading()
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            // Your code here
            Progress.sharedInstance.dismissLoading()
            if(error != nil){
                Toast.show(message: "Failed to send reset email!", controller: self)
                return
            }
            Toast.show(message: "We have sent you instructions to reset your password!", controller: self)
        }
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
