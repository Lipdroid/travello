//
//  InfoDialog.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/9/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
import UIKit

class InfoDialog: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init(title: String,body: String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title,body: body)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title: String,body: String){
        dialogView.clipsToBounds = true
        //for the black transparent background
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        
        //title text
        let titleLabel = UITextView(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: .greatestFiniteMagnitude))
        let title = title
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.attributedText = attributedText(value: title)
        titleLabel.sizeToFit()
        titleLabel.isEditable = false
        dialogView.addSubview(titleLabel)
        
        //separator line
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        //description
        let description = UITextView(frame:CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 300))
        description.frame.origin = CGPoint(x: 8, y: separatorLineView.frame.height + separatorLineView.frame.origin.y)
        description.isEditable = false
        description.text = body
        description.textAlignment = .left
        dialogView.addSubview(description)
    
        
        //Button Accept View
        let buttonAccept = UIButton()
        buttonAccept.backgroundColor = UIColor.lightGray
        buttonAccept.setTitle("OK", for: .normal)
        buttonAccept.setTitleColor(UIColor.black, for: .normal)
        buttonAccept.layer.cornerRadius = 3
        buttonAccept.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        buttonAccept.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        buttonAccept.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onAgree)))
        
        //Stack View
        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.fillEqually
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing   = 8.0
        
        stackView.frame.origin = CGPoint(x: 8, y: description.frame.height + description.frame.origin.y + 8)
        stackView.frame.size = CGSize(width: dialogViewWidth - 16 , height: 40)
        
        stackView.addArrangedSubview(buttonAccept)
        stackView.translatesAutoresizingMaskIntoConstraints = true
        
        dialogView.addSubview(stackView)
        
        let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + description.frame.height + stackView.frame.height + 8
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    @objc func onCancel(){
        dismiss(animated: true)
        exit(0)
    }
    
    @objc func onAgree(){
        dismiss(animated: true)
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String{
            //save the version in userDefaults
            UserDefaults.standard.set(version, forKey: Constants.VERSION)
        }
        
    }
    
    func attributedText(value: String) -> NSAttributedString {
        
        let string = value as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15.0)])
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15.0)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: value))
        // 4
        return attributedString
    }
    
}
