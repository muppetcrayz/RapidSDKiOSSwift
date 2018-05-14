//
//  ViewController.swift
//  MobileAPI
//
//  Created by Sage Conger on 5/14/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

import UIKit
import Foundation

var session_id: String = ""
var user_id: String = ""

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

        let authenticateString = "https://api.dubtel.com/v1/login"
        
        var request = URLRequest(url: URL(string: authenticateString)!)
        request.httpMethod = "POST"
        
        let postString = "username=" + usernameField.text! + "&password=" + passwordField.text!
        
        request.httpBody = postString.data(using: .utf8)
        request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
        
            guard let unwrappedData = data else { print("Error unwrapping data"); return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseJSON = try jsonDecoder.decode(LoginResponse.self, from: unwrappedData)
                session_id = responseJSON.session_id!
                user_id = responseJSON.user_id!
                completion(responseJSON.session_id != .none)
            } catch {
                completion(false)
            }
            
        }
        task.resume()
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

