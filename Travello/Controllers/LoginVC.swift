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
        //show a dialog pop up
        let alert = TermsAlertView()
        alert.show(animated: true)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

