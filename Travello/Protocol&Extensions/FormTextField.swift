//
//  FormTextField.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/8/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class FormTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
