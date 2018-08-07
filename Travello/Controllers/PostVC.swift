//
//  PostVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/7/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import iOSDropDown
class PostVC: UIViewController {
    @IBOutlet weak var from_address_dropdown: DropDown!
    
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The list of array to display. Can be changed dynamically
        from_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        from_address_dropdown.didSelect{
            (selectedText , index ,id) in
            Toast.show(message: "Selected String: \(selectedText) \n index: \(index)", controller: self)
        }
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
