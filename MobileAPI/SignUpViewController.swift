//
//  SignUpViewController.swift
//  MobileAPI
//
//  Created by Sage Conger on 5/14/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

import UIKit

var responseJSON = LogoutResponse(status: "", message: "")

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var missingLabel: UILabel!
    @IBOutlet weak var existsLabel: UILabel!
    @IBOutlet weak var couldNotRegisterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inputIsValid(completion: @escaping (Bool) -> Void) {
        
        let authenticateString = "https://api.dubtel.com/v1/register"
        
        var request = URLRequest(url: URL(string: authenticateString)!)
        request.httpMethod = "POST"
        
        let postString = "firstname=" + firstNameField.text! + "&lastname=" + lastNameField.text! + "&email=" + emailField.text! + "&password=" + passwordField.text!
        
        request.httpBody = postString.data(using: .utf8)
        request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let unwrappedData = data else { print("Error unwrapping data"); return }
            
            do {
                let jsonDecoder = JSONDecoder()
                responseJSON = try jsonDecoder.decode(LogoutResponse.self, from: unwrappedData)
                completion(responseJSON.status == "Success")
            } catch {
                completion(false)
            }
            
        }
        task.resume()
        
    }
    
    // okay what you still need to do is make it register and do fields required: something missing? pop up a thing. user already exists? pop up a thing. unable to register? pop up a thing. successful? do the segue.
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if (firstNameField.text?.isEmpty == false) && (lastNameField.text?.isEmpty == false) && (emailField.text?.isEmpty == false) && (passwordField.text?.isEmpty == false) {
            inputIsValid { valid in
                if valid {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "signUpToLoginSegue", sender: self)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        if (responseJSON.status == "Failed" && responseJSON.message == "User already exists for this application.") {
                            self.existsLabel.isHidden = false
                        }
                        else if (responseJSON.status == "Failed" && responseJSON.message == "Unable to register user to the application.") {
                            self.couldNotRegisterLabel.isHidden = false
                        }
                    }
                }
            }
        }
        else {
            self.missingLabel.isHidden = false
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

