//
//  ViewController.swift
//  PasswordStrength
//
//  Created by Leonardo Edelman Wajnsztok on 17/12/16.
//  Copyright © 2016 Leonardo Wajnsztok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var passwordStrength: PasswordStrengthView!
    var passwordTextField: UITextField!
    var submitButton: UIButton!
    var mayPressButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        passwordTextField = UITextField()
        passwordTextField.delegate = self
        passwordTextField.frame.size = CGSize(width: view.frame.width * 0.7, height: 40)
        passwordTextField.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.4)
        passwordTextField.placeholder = "Password here"
        view.addSubview(passwordTextField)
        
        let frame = CGRect(x: passwordTextField.frame.origin.x, y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height, width: passwordTextField.frame.size.width, height: 100)
        passwordStrength = PasswordStrengthView(frame: frame)
        passwordStrength.enableHints = false
        passwordStrength.addRule(text: "Must contain 'leotok' or 'Leotok'", regex: "([a-zA-Z])*((leotok)|(Leotok))([a-zA-Z])*")
        passwordStrength.enableHints = true
        
        view.addSubview(passwordStrength)
        
        submitButton = UIButton()
        submitButton.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
        submitButton.frame.size = CGSize(width: 100, height: 50)
        submitButton.center = CGPoint(x: view.center.x, y: view.frame.height * 0.8)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(UIColor.black, for: .normal)
        submitButton.isEnabled = false
        view.addSubview(submitButton)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = textField.text as NSString? ?? ""
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        mayPressButton = passwordStrength.updateStrength(password: txtAfterUpdate)
        
        if mayPressButton {
            submitButton.isEnabled = false
        }
        else {
            submitButton.isEnabled = true
        }
        
        return true

    }
    
}

