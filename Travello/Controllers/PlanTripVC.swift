//
//  PlanTripVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/11/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import iOSDropDown
import DLRadioButton
class PlanTripVC: UIViewController {
    
    @IBOutlet weak var radioButton: DLRadioButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var from_address_dropdown: DropDown!
    @IBOutlet weak var to_address_dropdown: DropDown!
    var from_city_txt: String = "София"
    var to_city_txt: String = "София"
    @IBOutlet weak var btn_or: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.resizeScrollViewContentSize()
        setUpDropdowns()
        //make the OR button round
        btn_or.layer.cornerRadius = 0.5 * btn_or.bounds.size.width
        btn_or.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpDropdowns(){
        // The list of array to display. Can be changed dynamically
        from_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        //get location from string city name
        from_address_dropdown.didSelect{
            (selectedText , index ,id) in
            self.from_city_txt = selectedText;
            
        }
        
        // The list of array to display. Can be changed dynamically
        to_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        to_address_dropdown.didSelect{
            (selectedText , index ,id) in
            self.to_city_txt = selectedText;
        }
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
