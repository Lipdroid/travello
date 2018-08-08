//
//  PostVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/7/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import iOSDropDown
import DatePickerDialog

class PostVC: UIViewController {
    @IBOutlet weak var from_address_dropdown: DropDown!
    @IBOutlet weak var to_address_dropdown: DropDown!
    
    @IBOutlet weak var details: FormTextField!
    @IBOutlet weak var gas_fare: FormTextField!
    @IBOutlet weak var seat: FormTextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_date: UIButton!
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func afterClickSubmit(_ sender: Any) {
    }
    @IBAction func afterClickDate(_ sender: Any) {
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: UIColor(hexColor: "26ae90"),
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        datePicker.show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.date.text = formatter.string(from: dt)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropdowns()
        //round the buttons
        btn_date.layer.cornerRadius = 15
        btn_submit.layer.cornerRadius = 15
        scrollView.resizeScrollViewContentSize()

    }
    
    private func setUpDropdowns(){
        // The list of array to display. Can be changed dynamically
        from_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        from_address_dropdown.didSelect{
            (selectedText , index ,id) in
            Toast.show(message: "Selected String: \(selectedText) \n index: \(index)", controller: self)
        }
        
        // The list of array to display. Can be changed dynamically
        to_address_dropdown.optionArray = cities
        // The the Closure returns Selected Index and String
        to_address_dropdown.didSelect{
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

extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}
extension UIColor {
    convenience init(hexColor: String) {
        let scannHex = Scanner(string: hexColor)
        var rgbValue: UInt64 = 0
        scannHex.scanLocation = 0
        scannHex.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
