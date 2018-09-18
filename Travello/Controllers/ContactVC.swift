//
//  ChatVC.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/13/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ContactVC: ButtonBarPagerTabStripViewController {
    
    var mUserObj: UserObject! = nil
    
    @IBAction func afterClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor(hexColor: "55C4D9")
        settings.style.buttonBarItemBackgroundColor = UIColor(hexColor: "55C4D9")
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        super.viewDidLoad()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
        return [child_1, child_2]
    }

}
