//
//  ViewController.swift
//  MobileAPI
//
//  Created by Sage Conger on 5/14/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitPressed(submitButton)
        return true
    }
    
    func inputIsValid(completion: @escaping (Bool) -> Void) {
        
        // TODO: authorization header
        
        let authenticateString = "https://api.dubtel.com/v1/login?username=" + usernameField.text! + "&password=" + passwordField.text!
        let authenticate = URL(string: authenticateString)
        
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        if (usernameField.text?.isEmpty == false) && (passwordField.text?.isEmpty == false) {
            inputIsValid { valid in
                if valid {
                    DispatchQueue.main.async {
                        self.incorrectLabel.isHidden = true
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.incorrectLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "logInToSignUpSegue", sender: self)
    }
    
}

